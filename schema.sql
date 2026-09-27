-- ============================================================
-- MindGameTrainer — schema Supabase
-- Incolla tutto questo nell'SQL Editor di Supabase e premi RUN.
-- ============================================================

-- Registro dei nickname (per il menu a tendina)
create table if not exists players (
  nickname   text primary key,
  created_at timestamptz default now()
);

-- Ogni singolo mindgame giocato = una riga (dataset grezzo per stat, ranking e futuro training AI)
create table if not exists events (
  id         bigint generated always as identity primary key,
  nickname   text    not null,
  role       text    not null check (role in ('attack','defense')),
  mode       text,                         -- 'single' | 'full'
  dv         int,                          -- difesa bodypart (solo modalità full)
  move       smallint not null check (move between 1 and 4),  -- numero detto dal giocatore
  bot        smallint not null check (bot  between 1 and 4),  -- numero del bot
  outcome    smallint not null check (outcome in (0,1)),      -- 1 = mindgame vinto dal giocatore
  match_end  smallint not null default 0 check (match_end in (0,1,2)), -- 0 nessuno, 1 match vinto, 2 match perso
  session_id text,                         -- run di gioco continua (per le sequenze)
  seq        int,                          -- posizione nella run
  created_at timestamptz default now()
);
create index if not exists events_nick_idx on events (nickname, id);

-- ---------- Sicurezza (Row Level Security) ----------
-- Chiunque (chiave pubblica anon) può: leggere tutto, registrare un nickname, inserire partite.
-- Nessuno può modificare o cancellare dati altrui (append-only).
alter table players enable row level security;
alter table events  enable row level security;

drop policy if exists players_sel on players;
drop policy if exists players_ins on players;
drop policy if exists events_sel  on events;
drop policy if exists events_ins  on events;

create policy players_sel on players for select using (true);
create policy players_ins on players for insert with check (true);
create policy events_sel  on events  for select using (true);
create policy events_ins  on events  for insert with check (true);

grant usage on schema public to anon, authenticated;
grant select, insert on players to anon, authenticated;
grant select, insert on events  to anon, authenticated;

-- ============================================================
-- ESPORTARE I DATI PER IL TRAINING (quando vorrai):
--   Table Editor → events → Export → CSV
--   oppure query:  select * from events order by id;
-- ============================================================
