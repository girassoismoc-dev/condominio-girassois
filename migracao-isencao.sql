-- Rodar no SQL Editor do Supabase (projeto sbfimuyismkgreyxujbo).
-- Casa isenta de taxa (ex.: a do síndico) — continua contando no total de
-- 27 casas, mas some da inadimplência e não recebe cobrança.

alter table casas add column if not exists isenta boolean not null default false;

update casas set isenta = true where numero = 18;
