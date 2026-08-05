-- ============================================================
-- Parque dos Girassóis — Forçar logout de todos os moradores
-- Rodar UMA VEZ no SQL Editor do Supabase (projeto sbfimuyismkgreyxujbo).
-- ============================================================

alter table config_geral add column if not exists sessao_min timestamptz not null default now();
