-- =============================================================================
-- JanSeva Migration 005: Profile Avatar Support
-- =============================================================================
-- Adds avatar_url column to public.profiles table
-- =============================================================================

alter table if exists public.profiles
  add column if not exists avatar_url text;

comment on column public.profiles.avatar_url is
  'Public or signed URL of the citizen profile photo stored in Supabase Storage.';
