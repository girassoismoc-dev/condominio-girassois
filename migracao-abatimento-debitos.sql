-- Liga cada débito antigo aos meses que ele efetivamente cobre, pra poder
-- abater automaticamente quando um pagamento "referente a" um desses meses
-- é lançado.

alter table debitos_antigos add column if not exists meses_cobertos text[];

-- Preenche os 10 débitos já cadastrados, com base no texto de "referente_a"
-- de cada um (conferido manualmente com o síndico nessa mesma conversa).
update debitos_antigos set meses_cobertos = ARRAY['Maio/2026','Junho/2026','Julho/2026'] where casa = 1;
update debitos_antigos set meses_cobertos = ARRAY['Julho/2026'] where casa = 2;
update debitos_antigos set meses_cobertos = ARRAY[]::text[] where casa = 4; -- débito é só 2024/2025, não toca 2026
update debitos_antigos set meses_cobertos = ARRAY['Janeiro/2026','Fevereiro/2026','Março/2026','Abril/2026','Maio/2026','Junho/2026','Julho/2026','Agosto/2026','Setembro/2026','Outubro/2026','Novembro/2026'] where casa = 8;
update debitos_antigos set meses_cobertos = ARRAY['Fevereiro/2026','Abril/2026','Junho/2026','Julho/2026'] where casa = 15;
update debitos_antigos set meses_cobertos = ARRAY['Março/2026','Abril/2026','Maio/2026','Junho/2026','Julho/2026'] where casa = 16;
update debitos_antigos set meses_cobertos = ARRAY['Janeiro/2026','Fevereiro/2026','Março/2026','Abril/2026','Maio/2026','Junho/2026','Julho/2026'] where casa = 19;
update debitos_antigos set meses_cobertos = ARRAY['Novembro/2025','Dezembro/2025','Janeiro/2026','Fevereiro/2026','Março/2026','Abril/2026','Maio/2026','Junho/2026','Julho/2026'] where casa = 21;
update debitos_antigos set meses_cobertos = ARRAY['Maio/2026','Junho/2026','Julho/2026'] where casa = 23;
update debitos_antigos set meses_cobertos = ARRAY['Fevereiro/2026','Março/2026','Junho/2026'] where casa = 24;

-- Conferir depois de rodar:
-- select casa, referente_a, valor, meses_cobertos from debitos_antigos order by casa;
