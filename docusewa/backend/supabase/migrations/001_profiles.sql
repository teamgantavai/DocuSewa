-- =============================================================================
-- JanSeva Migration 001: Citizen Profiles
-- =============================================================================
-- Run this first in your Supabase SQL Editor.
-- This table mirrors auth.users with a 1:1 relationship.
-- A profile row is auto-created when a new citizen verifies their phone OTP.
-- =============================================================================

-- Enable UUID extension (already enabled in Supabase by default)
create extension if not exists "uuid-ossp";

-- ---------------------------------------------------------------------------
-- profiles table
-- ---------------------------------------------------------------------------
create table if not exists public.profiles (
  -- Primary key matches auth.users.id exactly
  id              uuid        primary key references auth.users(id) on delete cascade,

  -- Contact
  phone           text        unique,
  email           text,
  full_name       text,
  display_name    text,

  -- Account meta
  account_type    text        not null default 'citizen'
                              check (account_type in ('citizen', 'provider', 'admin')),
  account_status  text        not null default 'active'
                              check (account_status in ('active', 'suspended', 'pending_verification')),

  -- Onboarding
  is_new_user     boolean     not null default true,
  onboarding_completed boolean not null default false,

  -- Audit
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

comment on table public.profiles is
  'JanSeva citizen profiles. One row per Supabase auth user. '
  'id = auth.users.id ensures single identity across web and mobile.';

-- ---------------------------------------------------------------------------
-- Auto-update updated_at on every row change
-- ---------------------------------------------------------------------------
create or replace function public.handle_updated_at()
returns trigger
language plpgsql
security definer
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_updated_at on public.profiles;
create trigger profiles_updated_at
  before update on public.profiles
  for each row execute procedure public.handle_updated_at();

-- ---------------------------------------------------------------------------
-- Auto-create profile when a new Supabase auth user is created (phone OTP)
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, phone, email, full_name)
  values (
    new.id,
    new.phone,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', null)
  )
  on conflict (id) do nothing;  -- idempotent
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Index
-- ---------------------------------------------------------------------------
create index if not exists profiles_phone_idx on public.profiles(phone);
create index if not exists profiles_account_type_idx on public.profiles(account_type);
