// ============================================================
// Parque dos Girassóis — Configuração do Supabase
// Inclua este arquivo em todas as páginas, antes dos demais scripts
// ============================================================

const SUPABASE_URL = 'https://sbfimuyismkgreyxujbo.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_GiqnQnUo10i8A_JliHBwCw__FdCf4py';

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
