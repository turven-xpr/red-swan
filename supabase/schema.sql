-- =====================================================================
-- DEUTSCHY — Cloud Database Schema & Row Level Security (RLS)
-- Target Platform: Supabase (PostgreSQL 15+)
-- =====================================================================

-- 1. Enable required extensions
create extension if not exists "uuid-ossp";

-- =====================================================================
-- TABLE: public.profiles
-- User learning profile, CEFR levels, streak tracking & study settings
-- =====================================================================
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  display_name text,
  email text,
  avatar_url text,
  native_language text default 'en',     -- 'en', 'ar', 'fr' (from Onboarding Step 1)
  reason text default 'study',           -- 'ausbildung', 'study', 'job', 'travel', 'fun' (Step 2)
  start_level text default 'A0',         -- 'A0', 'A1', 'A2', 'B1', 'B2' (Step 3)
  current_level text default 'A0',       -- Progresses as end-of-level tests are passed
  daily_goal_minutes int default 15,     -- 3, 5, 15, 30, 60, 120 (Step 4)
  current_streak int default 0,
  longest_streak int default 0,
  last_activity_date date,
  xp int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Index for streak & activity queries
create index if not exists idx_profiles_last_activity on public.profiles(last_activity_date);
create index if not exists idx_profiles_current_level on public.profiles(current_level);

-- =====================================================================
-- AUTOMATIC PROFILE CREATION TRIGGER
-- When a user registers in auth.users (Google, Apple, Email, Guest),
-- an empty profile row is created automatically.
-- =====================================================================
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (
    id,
    display_name,
    email,
    avatar_url,
    created_at,
    updated_at
  ) values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', 'Deutschy Learner'),
    new.email,
    new.raw_user_meta_data->>'avatar_url',
    now(),
    now()
  )
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

-- Drop trigger if already exists to ensure idempotency
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- =====================================================================
-- TABLE: public.tests
-- Level Gate Tests (to pass from A0->A1->A2...) and Goethe / telc exams
-- =====================================================================
create table if not exists public.tests (
  id uuid primary key default gen_random_uuid(),
  level text not null,                  -- 'A0', 'A1', 'A2', 'B1', 'B2'
  category text not null,               -- 'level_gate' or 'goethe_practice' or 'telc_practice'
  title text not null,
  description text,
  duration_minutes int default 20,
  pass_percentage int default 70,       -- Minimum score % required to pass
  questions jsonb not null default '[]'::jsonb, -- Array of {question, options, correct_index, explanation}
  is_active boolean default true,
  created_at timestamptz default now()
);

create index if not exists idx_tests_level on public.tests(level);
create index if not exists idx_tests_category on public.tests(category);

-- =====================================================================
-- TABLE: public.user_test_results
-- History of test attempts, scores, and unlock achievements
-- =====================================================================
create table if not exists public.user_test_results (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade not null,
  test_id uuid references public.tests(id) on delete cascade not null,
  score int not null,                   -- 0 to 100 percentage
  passed boolean not null,
  answers jsonb,                        -- User submitted answers
  xp_earned int default 0,
  attempted_at timestamptz default now()
);

create index if not exists idx_user_test_results_user on public.user_test_results(user_id);
create index if not exists idx_user_test_results_test on public.user_test_results(test_id);

-- =====================================================================
-- TABLE: public.ai_chat_messages
-- Personalized German AI Tutor conversation log
-- =====================================================================
create table if not exists public.ai_chat_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade not null,
  role text not null check (role in ('user', 'assistant', 'system')),
  content text not null,
  correction text,                      -- German grammar corrections / feedback
  translation text,                     -- Translation in native language
  created_at timestamptz default now()
);

create index if not exists idx_ai_chat_messages_user on public.ai_chat_messages(user_id, created_at);

-- =====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Strict user-isolation: users can only see & touch their own records
-- =====================================================================

-- Profiles RLS
alter table public.profiles enable row level security;

create policy "Users can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Tests RLS (Anyone authenticated can read active tests)
alter table public.tests enable row level security;

create policy "Authenticated users can view active tests"
  on public.tests for select
  using (auth.role() = 'authenticated' and is_active = true);

-- User Test Results RLS
alter table public.user_test_results enable row level security;

create policy "Users can view their own test results"
  on public.user_test_results for select
  using (auth.uid() = user_id);

create policy "Users can insert their own test results"
  on public.user_test_results for insert
  with check (auth.uid() = user_id);

-- AI Chat Messages RLS
alter table public.ai_chat_messages enable row level security;

create policy "Users can view their own AI chat messages"
  on public.ai_chat_messages for select
  using (auth.uid() = user_id);

create policy "Users can insert their own AI chat messages"
  on public.ai_chat_messages for insert
  with check (auth.uid() = user_id);

-- =====================================================================
-- HELPER STORED PROCEDURE: Record daily activity and calculate streak
-- =====================================================================
create or replace function public.record_user_activity(p_user_id uuid, p_xp_gain int default 10)
returns jsonb as $$
declare
  v_today date := current_date;
  v_last_date date;
  v_streak int;
  v_longest int;
  v_new_xp int;
begin
  select last_activity_date, current_streak, longest_streak, xp
    into v_last_date, v_streak, v_longest, v_new_xp
    from public.profiles
   where id = p_user_id;

  if not found then
    return jsonb_build_object('error', 'Profile not found');
  end if;

  if v_last_date is null then
    v_streak := 1;
  elsif v_last_date = v_today then
    -- Already active today, streak remains unchanged
  elsif v_last_date = v_today - interval '1 day' then
    -- Consecutive day! Increment streak
    v_streak := v_streak + 1;
  else
    -- Missed more than 1 day, reset streak to 1
    v_streak := 1;
  end if;

  v_longest := greatest(coalesce(v_longest, 0), v_streak);
  v_new_xp := coalesce(v_new_xp, 0) + p_xp_gain;

  update public.profiles
     set last_activity_date = v_today,
         current_streak = v_streak,
         longest_streak = v_longest,
         xp = v_new_xp,
         updated_at = now()
   where id = p_user_id;

  return jsonb_build_object(
    'current_streak', v_streak,
    'longest_streak', v_longest,
    'xp', v_new_xp
  );
end;
$$ language plpgsql security definer;

