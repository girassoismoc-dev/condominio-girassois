-- Guarda quando cada morador acessou o painel dele pela última vez, pra
-- aparecer numa aba própria no painel do síndico.

alter table moradores add column if not exists ultimo_acesso timestamptz;
