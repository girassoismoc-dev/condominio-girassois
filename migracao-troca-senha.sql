-- Rodar no SQL Editor do Supabase (projeto sbfimuyismkgreyxujbo).
-- Adiciona a trava de "trocar senha no primeiro acesso".

alter table moradores
  add column if not exists precisa_trocar_senha boolean not null default true;

-- moradores que já tinham senha cadastrada antes dessa coluna existir:
-- deixa como "precisa trocar" também, já que nunca passaram por essa tela.
update moradores set precisa_trocar_senha = true where precisa_trocar_senha is null;
