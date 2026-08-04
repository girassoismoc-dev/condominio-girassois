-- Adiciona campo de data (escolhida pelo síndico) nos lançamentos de
-- receitas e despesas. Lançamentos antigos ficam com data em branco (—).

alter table receitas add column if not exists data date;
alter table despesas add column if not exists data date;
