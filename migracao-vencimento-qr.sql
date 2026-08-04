-- Rodar no SQL Editor do Supabase (projeto sbfimuyismkgreyxujbo).
-- Dia de vencimento configurável (era fixo em 10, virando 15).

alter table config_geral add column if not exists dia_vencimento integer not null default 15;
update config_geral set dia_vencimento = 15 where id = 1;
