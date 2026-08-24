-- =============================================================================
-- JanSeva Migration 002: Service Requests
-- =============================================================================
-- Run after 001_profiles.sql
-- Citizens create service requests that are visible on both web and mobile
-- via the same Supabase project (same user_id, same data).
-- =============================================================================

-- ---------------------------------------------------------------------------
-- service_requests table
-- ---------------------------------------------------------------------------
create table if not exists public.service_requests (
  id              uuid        primary key default uuid_generate_v4(),

  -- Owner — references the citizen's auth.users.id via profiles
  user_id         uuid        not null references public.profiles(id) on delete cascade,

  -- Request details
  title           text        not null,
  description     text,
  category        text        not null default 'general'
                              check (category in (
                                'aadhaar', 'ration_card', 'income_certificate',
                                'property', 'pension', 'passport', 'driving_licence',
                                'birth_certificate', 'death_certificate', 'other', 'general'
                              )),

  -- Status lifecycle
  status          text        not null default 'submitted'
                              check (status in (
                                'draft', 'submitted', 'under_review',
                                'additional_info_required', 'approved',
                                'rejected', 'completed', 'cancelled'
                              )),

  -- Provider assignment (nullable — set when provider picks up the request)
  assigned_provider_id uuid   references public.profiles(id) on delete set null,

  -- Priority
  priority        text        not null default 'normal'
                              check (priority in ('low', 'normal', 'high', 'urgent')),

  -- Tracking
  reference_number text       unique generated always as (
    'JS-' || to_char(created_at, 'YYYYMMDD') || '-' ||
    upper(substring(id::text, 1, 6))
  ) stored,

  -- Audit
  submitted_at    timestamptz,
  resolved_at     timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

comment on table public.service_requests is
  'Citizen service requests. Visible on both web and mobile via the same Supabase '
  'project. RLS ensures each citizen sees only their own requests.';

-- Updated_at trigger
drop trigger if exists service_requests_updated_at on public.service_requests;
create trigger service_requests_updated_at
  before update on public.service_requests
  for each row execute procedure public.handle_updated_at();

-- Auto-set submitted_at when status moves to submitted
create or replace function public.handle_service_request_submission()
returns trigger
language plpgsql
security definer
as $$
begin
  if new.status = 'submitted' and old.status = 'draft' then
    new.submitted_at = now();
  end if;
  if new.status in ('approved', 'rejected', 'completed') and new.resolved_at is null then
    new.resolved_at = now();
  end if;
  return new;
end;
$$;

drop trigger if exists service_request_status_change on public.service_requests;
create trigger service_request_status_change
  before update on public.service_requests
  for each row execute procedure public.handle_service_request_submission();

-- ---------------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------------
create index if not exists service_requests_user_id_idx on public.service_requests(user_id);
create index if not exists service_requests_status_idx on public.service_requests(status);
create index if not exists service_requests_category_idx on public.service_requests(category);
create index if not exists service_requests_created_at_idx on public.service_requests(created_at desc);
