-- Aida Supabase SQL Setup
-- Run this in Supabase SQL Editor

-- Chat Sessions Table
create table if not exists public.aida_chat_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'New consultation',
  patient_context jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Chat Messages Table
create table if not exists public.aida_chat_messages (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.aida_chat_sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('user', 'assistant')),
  content text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- Diseases Table
create table if not exists public.aida_diseases (
  id serial primary key,
  name text not null unique,
  symptoms jsonb not null default '[]'::jsonb,
  remedies text not null default '',
  prescriptions text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Stats Table
create table if not exists public.aida_stats (
  id serial primary key,
  visits integer not null default 0,
  signups_today integer not null default 0,
  total_users integer not null default 0,
  total_msgs integer not null default 0,
  updated_at timestamptz not null default now()
);

insert into public.aida_stats (id, visits, signups_today, total_users, total_msgs)
values (1, 0, 0, 0, 0)
on conflict (id) do nothing;

-- Daily Metrics Table
create table if not exists public.aida_daily_metrics (
  id serial primary key,
  metric_date date not null default current_date,
  new_users integer not null default 0,
  user_msgs integer not null default 0,
  bot_replies integer not null default 0,
  page_visits integer not null default 0,
  unique (metric_date)
);

-- Increment Stat Function
create or replace function public.aida_increment_stat(stat_name text, delta integer default 1)
returns void language plpgsql security definer as $$
begin
  if stat_name = 'visits' then
    update public.aida_stats set visits = visits + delta, updated_at = now() where id = 1;
  elsif stat_name = 'signups_today' then
    update public.aida_stats set signups_today = signups_today + delta, updated_at = now() where id = 1;
  elsif stat_name = 'total_users' then
    update public.aida_stats set total_users = total_users + delta, updated_at = now() where id = 1;
  elsif stat_name = 'total_msgs' then
    update public.aida_stats set total_msgs = total_msgs + delta, updated_at = now() where id = 1;
  end if;
end;
$$;

-- Enable Row Level Security
alter table public.aida_chat_sessions enable row level security;
alter table public.aida_chat_messages enable row level security;
alter table public.aida_diseases enable row level security;
alter table public.aida_stats enable row level security;
alter table public.aida_daily_metrics enable row level security;

-- RLS Policies
create policy "Users own sessions" on public.aida_chat_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Users own messages" on public.aida_chat_messages
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Anyone read diseases" on public.aida_diseases for select using (true);
create policy "Auth manage diseases" on public.aida_diseases for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create policy "Anyone read stats" on public.aida_stats for select using (true);
create policy "Auth update stats" on public.aida_stats for update
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create policy "Anyone read metrics" on public.aida_daily_metrics for select using (true);
create policy "Auth manage metrics" on public.aida_daily_metrics for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- Grants
grant usage on schema public to anon, authenticated;
grant select on public.aida_diseases to anon, authenticated;
grant insert, update, delete on public.aida_diseases to authenticated;
grant select on public.aida_stats to anon, authenticated;
grant update on public.aida_stats to authenticated;
grant select on public.aida_daily_metrics to anon, authenticated;
grant insert, update, delete on public.aida_daily_metrics to authenticated;
grant select, insert, update, delete on public.aida_chat_sessions to authenticated;
grant select, insert, update, delete on public.aida_chat_messages to authenticated;