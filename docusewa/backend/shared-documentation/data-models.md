# JanSeva — Shared Data Models

This document is the **canonical reference** for all data structures shared between
the web frontend (TypeScript) and the mobile frontend (Dart).

Both frontends must implement these models to match the Supabase PostgreSQL schema.

---

## 1. CitizenProfile

**Table:** `public.profiles`

### PostgreSQL → TypeScript → Dart

| Column | PostgreSQL | TypeScript | Dart |
|--------|-----------|------------|------|
| `id` | `uuid` | `string` | `String` |
| `phone` | `text` | `string \| null` | `String?` |
| `email` | `text` | `string \| null` | `String?` |
| `full_name` | `text` | `string \| null` | `String?` |
| `display_name` | `text` | `string \| null` | `String?` |
| `account_type` | `text` | `'citizen' \| 'provider' \| 'admin'` | `AccountType enum` |
| `account_status` | `text` | `'active' \| 'suspended' \| 'pending_verification'` | `AccountStatus enum` |
| `is_new_user` | `boolean` | `boolean` | `bool` |
| `onboarding_completed` | `boolean` | `boolean` | `bool` |
| `created_at` | `timestamptz` | `string` | `DateTime` |
| `updated_at` | `timestamptz` | `string` | `DateTime` |

---

## 2. ServiceRequest

**Table:** `public.service_requests`

| Column | PostgreSQL | TypeScript | Dart |
|--------|-----------|------------|------|
| `id` | `uuid` | `string` | `String` |
| `user_id` | `uuid` | `string` | `String` |
| `title` | `text` | `string` | `String` |
| `description` | `text` | `string \| null` | `String?` |
| `category` | `text` | `ServiceCategory` | `ServiceCategory enum` |
| `status` | `text` | `RequestStatus` | `RequestStatus enum` |
| `priority` | `text` | `'low' \| 'normal' \| 'high' \| 'urgent'` | `RequestPriority enum` |
| `reference_number` | `text` | `string` | `String` |
| `assigned_provider_id` | `uuid` | `string \| null` | `String?` |
| `submitted_at` | `timestamptz` | `string \| null` | `DateTime?` |
| `resolved_at` | `timestamptz` | `string \| null` | `DateTime?` |
| `created_at` | `timestamptz` | `string` | `DateTime` |
| `updated_at` | `timestamptz` | `string` | `DateTime` |

### ServiceCategory values
`aadhaar`, `ration_card`, `income_certificate`, `property`, `pension`,
`passport`, `driving_licence`, `birth_certificate`, `death_certificate`, `other`, `general`

### RequestStatus values
`draft`, `submitted`, `under_review`, `additional_info_required`,
`approved`, `rejected`, `completed`, `cancelled`

---

## 3. Document

**Table:** `public.documents`

| Column | PostgreSQL | TypeScript | Dart |
|--------|-----------|------------|------|
| `id` | `uuid` | `string` | `String` |
| `user_id` | `uuid` | `string` | `String` |
| `service_request_id` | `uuid` | `string \| null` | `String?` |
| `name` | `text` | `string` | `String` |
| `original_filename` | `text` | `string` | `String` |
| `mime_type` | `text` | `string \| null` | `String?` |
| `file_size_bytes` | `bigint` | `number \| null` | `int?` |
| `storage_path` | `text` | `string` | `String` |
| `document_type` | `text` | `DocumentType` | `DocumentType enum` |
| `verification_status` | `text` | `VerificationStatus` | `VerificationStatus enum` |
| `uploaded_at` | `timestamptz` | `string` | `DateTime` |
| `verified_at` | `timestamptz` | `string \| null` | `DateTime?` |
| `expires_at` | `timestamptz` | `string \| null` | `DateTime?` |

---

## 4. Auth Identity

The citizen's identity is their Supabase `auth.users.id` (UUID).

```
Phone: +91 98765 43210
           │
           ▼
  Supabase Auth Phone OTP
           │
           ▼
  auth.users.id = "abc123-def456-..."
           │
           ├── profiles.id = "abc123-def456-..."    (same UUID)
           ├── service_requests.user_id = "abc123..." (FK)
           └── documents.user_id = "abc123..."       (FK)
```

This UUID is the **same** whether the citizen authenticates via:
- JanSeva Web (Next.js + `@supabase/supabase-js`)
- JanSeva Mobile (Flutter + `supabase_flutter`)

---

## 5. Realtime Subscriptions

Both frontends can subscribe to data changes using Supabase Realtime.

```
-- Subscribe to own service requests changing status
channel = supabase
  .channel('service_requests_changes')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'service_requests',
    filter: `user_id=eq.${userId}`
  }, handler)
  .subscribe()
```

RLS is enforced on Realtime — citizens only receive events for their own rows.
