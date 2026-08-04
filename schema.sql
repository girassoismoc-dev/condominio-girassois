-- ============================================================
-- Parque dos Girassóis — Schema inicial
-- Rodar no SQL Editor do Supabase (projeto sbfimuyismkgreyxujbo).
-- ============================================================

-- 27 casas fixas, numeradas 01 a 27, sem bloco.
create table if not exists casas (
  numero integer primary key check (numero between 1 and 27),
  isenta boolean not null default false
);
insert into casas (numero) select generate_series(1,27) on conflict do nothing;
alter table casas disable row level security;

-- Morador atual de cada casa (casa alugada muda de morador ao longo do tempo,
-- por isso é 1 registro "atual" por casa, sobrescrito pelo síndico ao trocar).
create table if not exists moradores (
  casa integer primary key references casas(numero),
  nome text not null,
  telefone text,
  email text,
  tipo text not null default 'Proprietário' check (tipo in ('Proprietário','Inquilino')),
  senha text not null default '1234',
  precisa_trocar_senha boolean not null default true,
  atualizado_em timestamptz not null default now()
);
alter table moradores disable row level security;

-- Configuração financeira/geral — sempre 1 linha só (id=1).
create table if not exists config_geral (
  id integer primary key default 1 check (id = 1),
  valor_taxa numeric not null default 75,
  dia_vencimento integer not null default 15,
  multa_pct numeric not null default 2.0,
  juros_pct numeric not null default 1.0,
  pix_tipo text default 'CNPJ',
  pix_chave text default '',
  pix_nome text default 'Condomínio Parque dos Girassóis',
  fundo_reserva numeric not null default 0,
  saldo_caixa numeric not null default 0,
  atualizado_em timestamptz not null default now()
);
insert into config_geral (id) values (1) on conflict (id) do nothing;
alter table config_geral disable row level security;

-- Pagamentos de taxa lançados pelo síndico (histórico, mês a mês).
create table if not exists pagamentos (
  id uuid primary key default gen_random_uuid(),
  casa integer not null references casas(numero),
  mes_ref text not null,        -- ex.: "Agosto/2026"
  valor numeric not null,
  data_pagamento date not null,
  criado_em timestamptz not null default now()
);
alter table pagamentos disable row level security;

-- Débitos anteriores a agosto/2026 — valor fixo, sem juros/multa, 1 por casa
-- (migração do controle antigo). Fica vazio/sem linha quando quitado.
create table if not exists debitos_antigos (
  casa integer primary key references casas(numero),
  referente_a text not null,    -- ex.: "Jun e Jul/2026"
  valor numeric not null,
  atualizado_em timestamptz not null default now()
);
alter table debitos_antigos disable row level security;

-- Serviços e implementações realizadas no condomínio (linha do tempo).
create table if not exists servicos (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  meta text not null,           -- ex.: "Concluído em 08/2026"
  descricao text,
  status text not null default 'progress' check (status in ('done','progress','ongoing')),
  criado_em timestamptz not null default now()
);
alter table servicos disable row level security;

-- Prestação de contas — lançamentos de receita e despesa por mês.
create table if not exists receitas (
  id uuid primary key default gen_random_uuid(),
  mes_ref text not null,        -- ex.: "2026-07"
  descricao text not null,
  valor numeric not null,
  criado_em timestamptz not null default now()
);
alter table receitas disable row level security;

create table if not exists despesas (
  id uuid primary key default gen_random_uuid(),
  mes_ref text not null,
  descricao text not null,
  valor numeric not null,
  criado_em timestamptz not null default now()
);
alter table despesas disable row level security;

-- Reservas da Área de Convivência.
create table if not exists reservas (
  id uuid primary key default gen_random_uuid(),
  casa integer not null references casas(numero),
  data date not null,
  hora_inicio time not null,
  hora_fim time not null,
  observacoes text,
  criado_em timestamptz not null default now(),
  unique (data, hora_inicio)
);
alter table reservas disable row level security;

-- Documentos: regimento (1 vigente), atas (várias), prestação de contas (1 por mês).
-- Os arquivos em si ficam no Storage do Supabase (bucket "documentos"); aqui só
-- guardamos nome/url/metadados.
create table if not exists documentos (
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('regimento','ata','prestacao_contas')),
  nome text not null,
  url text not null,
  mes_ref text,                 -- só relevante pra prestacao_contas
  publicado_em timestamptz not null default now()
);
alter table documentos disable row level security;

-- Fotos de modelos de cobertura permitidos (2 fotos de referência).
create table if not exists fotos_cobertura (
  id uuid primary key default gen_random_uuid(),
  url text not null,
  ordem integer not null default 1,
  atualizado_em timestamptz not null default now()
);
alter table fotos_cobertura disable row level security;

-- ============================================================
-- Storage — bucket público único pra regimento, atas, prestação de
-- contas (PDFs) e fotos de cobertura. Sem policy restritiva, pra
-- combinar com o padrão do resto do sistema (RLS desligado nas
-- tabelas, controle de acesso só na aplicação).
-- ============================================================
insert into storage.buckets (id, name, public)
values ('arquivos','arquivos', true)
on conflict (id) do nothing;

create policy "arquivos leitura publica" on storage.objects for select using (bucket_id = 'arquivos');
create policy "arquivos upload publico" on storage.objects for insert with check (bucket_id = 'arquivos');
create policy "arquivos update publico" on storage.objects for update using (bucket_id = 'arquivos');
create policy "arquivos delete publico" on storage.objects for delete using (bucket_id = 'arquivos');

-- Conferir depois de rodar:
-- select * from casas order by numero;
-- select * from config_geral;
