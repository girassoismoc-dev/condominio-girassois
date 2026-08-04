-- Liga receitas ao pagamento de taxa que a gerou, pra poder editar/excluir
-- os dois juntos e pra separar "taxas" de outras receitas manuais.

alter table receitas add column if not exists pagamento_id uuid references pagamentos(id) on delete cascade;
