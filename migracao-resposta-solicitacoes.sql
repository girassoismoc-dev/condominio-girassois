-- Permite o síndico responder uma solicitação; a resposta aparece pro
-- morador que reportou, na própria aba Solicitações dele.

alter table solicitacoes add column if not exists resposta text;
alter table solicitacoes add column if not exists respondido_em timestamptz;
