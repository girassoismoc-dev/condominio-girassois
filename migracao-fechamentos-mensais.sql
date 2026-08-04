-- Fundo de reserva e saldo em caixa passam a ser um fechamento por mês
-- (igual receitas/despesas), em vez de um valor único e global.

create table if not exists fechamentos_mensais (
  mes_ref text primary key,
  fundo_reserva numeric not null default 0,
  saldo_caixa numeric not null default 0,
  atualizado_em timestamptz not null default now()
);
alter table fechamentos_mensais disable row level security;

-- Semeia o mês atual com os valores que já estavam em config_geral, pra não
-- "sumir" o número que o síndico já tinha cadastrado.
insert into fechamentos_mensais (mes_ref, fundo_reserva, saldo_caixa)
select
  (array['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'])[extract(month from now())::int]
    || '/' || extract(year from now())::text,
  fundo_reserva,
  saldo_caixa
from config_geral where id = 1
on conflict (mes_ref) do nothing;

-- Conferir depois de rodar:
-- select * from fechamentos_mensais order by mes_ref;
