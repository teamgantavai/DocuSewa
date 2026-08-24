-- =============================================================================
-- JanSeva Migration 003: Documents
-- =============================================================================
-- Run after 002_service_requests.sql
-- Citizen documents stored in Supabase Storage, metadata in this table.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- documents table
-- ---------------------------------------------------------------------------
create table if not exists public.documents (
  id              uuid        primary key default uuid_generate_v4(),

  -- Owner
  user_id         uuid        not null references public.profiles(id) on delete cascade,

  -- Linked service request (optional)
  service_request_id uuid     references public.service_requests(id) on delete set null,

  -- File info
  name            text        not null,
  original_filename text      not null,
  mime_type       text,
  file_size_bytes bigint,

  -- Supabase Storage path (bucket: 'citizen-documents')
  -- Format: {user_id}/{document_id}/{filename}
  storage_path    text        not null,

  -- Document type
  document_type   text        not null default 'other'
                              check (document_type in (
                                'aadhaar', 'pan', 'passport', 'driving_licence',
                                'ration_card', 'voter_id', 'income_certificate',
                                'birth_certificate', 'death_certificate',
                                'property_deed', 'utility_bill', 'photograph',
                                'signature', 'other'
                              )),

  -- Verification status
  verification_status text    not null default 'unverified'
                              check (verification_status in (
                                'unverified', 'pending_review', 'verified', 'rejected'
                              )),

  -- Audit
  uploaded_at     timestamptz not null default now(),
  verified_at     timestamptz,
  expires_at      timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

comment on table public.documents is
  'Citizen document metadata. Actual files are in Supabase Storage bucket '
  '''citizen-documents''. storage_path is the path within that bucket.';

-- Updated_at trigger
drop trigger if exists documents_updated_at on public.documents;
create trigger documents_updated_at
  before update on public.documents
  for each row execute procedure public.handle_updated_at();

-- ---------------------------------------------------------------------------
-- Storage bucket policy (create in Supabase Dashboard → Storage)
-- ---------------------------------------------------------------------------
-- Bucket name: citizen-documents
-- Private bucket (not public)
-- RLS policies defined in 004_rls_policies.sql

-- ---------------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------------
create index if not exists documents_user_id_idx on public.documents(user_id);
create index if not exists documents_service_request_idx on public.documents(service_request_id);
create index if not exists documents_type_idx on public.documents(document_type);
create index if not exists documents_verification_idx on public.documents(verification_status);
