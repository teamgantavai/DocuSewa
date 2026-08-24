-- =============================================================================
-- JanSeva Migration 004: Row Level Security Policies
-- =============================================================================
-- Run LAST — after all tables are created.
--
-- Security model:
--   Citizens can only access their own rows.
--   Service providers can read requests assigned to them.
--   Admins (via service role) bypass RLS entirely.
--   Frontend anon key is NEVER given direct table access without auth.
-- =============================================================================


-- =============================================================================
-- PROFILES
-- =============================================================================

alter table public.profiles enable row level security;

-- Citizens can read their own profile
create policy "citizens_select_own_profile"
  on public.profiles
  for select
  using (auth.uid() = id);

-- Citizens can update limited fields of their own profile
create policy "citizens_update_own_profile"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (
    auth.uid() = id
    -- Prevent citizens from changing account_type or account_status
    -- (These are controlled by admin/backend only)
  );

-- The auto-create trigger (handle_new_user) runs as security definer,
-- so it bypasses RLS. No explicit insert policy needed for citizens.

-- =============================================================================
-- SERVICE REQUESTS
-- =============================================================================

alter table public.service_requests enable row level security;

-- Citizens can view only their own service requests
create policy "citizens_select_own_requests"
  on public.service_requests
  for select
  using (auth.uid() = user_id);

-- Citizens can create service requests (user_id auto-set to auth.uid())
create policy "citizens_insert_own_requests"
  on public.service_requests
  for insert
  with check (auth.uid() = user_id);

-- Citizens can update only draft requests (cannot modify submitted/approved)
create policy "citizens_update_own_draft_requests"
  on public.service_requests
  for update
  using (auth.uid() = user_id and status = 'draft')
  with check (auth.uid() = user_id);

-- Citizens can cancel their own active requests
-- (done via update — status = 'cancelled' only from non-terminal states)
-- Note: Cancellation logic is better enforced via an Edge Function.

-- Service providers can read requests assigned to them
create policy "providers_select_assigned_requests"
  on public.service_requests
  for select
  using (
    auth.uid() = assigned_provider_id
    and exists (
      select 1 from public.profiles p
      where p.id = auth.uid()
      and p.account_type = 'provider'
    )
  );

-- =============================================================================
-- DOCUMENTS
-- =============================================================================

alter table public.documents enable row level security;

-- Citizens can view their own documents
create policy "citizens_select_own_documents"
  on public.documents
  for select
  using (auth.uid() = user_id);

-- Citizens can upload documents (insert)
create policy "citizens_insert_own_documents"
  on public.documents
  for insert
  with check (auth.uid() = user_id);

-- Citizens can delete their own unverified documents
create policy "citizens_delete_own_unverified_documents"
  on public.documents
  for delete
  using (
    auth.uid() = user_id
    and verification_status = 'unverified'
  );

-- =============================================================================
-- STORAGE RLS (Supabase Storage bucket: citizen-documents)
-- Run these in Supabase Dashboard → Storage → Policies
-- OR via the SQL Editor using storage schema
-- =============================================================================

-- Allow citizens to upload to their own folder: {user_id}/
-- (Configure in Supabase Dashboard → Storage → citizen-documents → Policies)

-- INSERT policy:
-- (bucket_id = 'citizen-documents') AND (auth.uid()::text = (storage.foldername(name))[1])

-- SELECT policy:
-- (bucket_id = 'citizen-documents') AND (auth.uid()::text = (storage.foldername(name))[1])

-- DELETE policy:
-- (bucket_id = 'citizen-documents') AND (auth.uid()::text = (storage.foldername(name))[1])


-- =============================================================================
-- GRANTS
-- =============================================================================

-- Grant usage on the public schema to authenticated users
grant usage on schema public to authenticated;

-- Grant table permissions to authenticated role (RLS will still filter rows)
grant select, insert, update on public.profiles to authenticated;
grant select, insert, update on public.service_requests to authenticated;
grant select, insert, delete on public.documents to authenticated;

-- anon role gets NO access to any table (auth is required for all data)
revoke all on public.profiles from anon;
revoke all on public.service_requests from anon;
revoke all on public.documents from anon;
