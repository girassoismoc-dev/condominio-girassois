-- Nova tabela: solicitações do morador (problema com foto, sugestão, ou
-- pedido de "esqueci minha senha" vindo do login).

create table if not exists solicitacoes (
  id uuid primary key default gen_random_uuid(),
  casa integer not null references casas(numero),
  tipo text not null check (tipo in ('problema','sugestao','senha')),
  mensagem text,
  foto_url text,
  status text not null default 'aberta' check (status in ('aberta','resolvida')),
  criado_em timestamptz not null default now()
);
alter table solicitacoes disable row level security;
