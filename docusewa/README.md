# DocuSewa Ecosystem

> **Government services, made simpler.**

DocuSewa is a secure platform for Indian citizens to access and manage government-related service requests through verified service providers.

---

## Architecture Overview

```
d:\DocSeva\docusewa\
├── backend/                  ← Supabase SQL migrations + RLS policies
├── docusewa-web/             ← React / Next.js 14 web application
└── (docusewa-mobile)         ← Flutter mobile app (at d:\DocSeva\docseva\)
```

### One Backend, Two Frontends

```
              ┌──────────────────────────────┐
              │          SUPABASE            │
              │                              │
              │  • auth.users (one identity) │
              │  • PostgreSQL + RLS          │
              │  • Storage                   │
              │  • Realtime                  │
              │  • Edge Functions            │
              └───────────────┬──────────────┘
                              │
               ┌──────────────┴──────────────┐
               │                             │
       ┌───────▼────────┐           ┌────────▼────────┐
       │  docusewa-web  │           │ docusewa-mobile │
       │  Next.js 14    │           │  Flutter        │
       │  TypeScript    │           │  Dart           │
       └────────────────┘           └─────────────────┘
```

A citizen who authenticates with `+91 98765 43210` on either platform gets **the same Supabase `auth.users.id`**, the same profile, and sees the same service requests.

---

## Quick Start

### Prerequisites
- Node.js 20+
- Flutter SDK 3.x
- A Supabase project (free tier works)

### 1. Set up Supabase
1. Create a project at [supabase.com](https://supabase.com)
2. Enable **Phone Auth** under Authentication → Providers → Phone
3. Configure Twilio (or another SMS provider) for OTP delivery
4. Run migrations in order from `backend/supabase/migrations/`

### 2. Web App
```sh
cd docusewa-web
cp .env.local.example .env.local
# Fill in your NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY
npm install
npm run dev
```

### 3. Mobile App
```sh
cd d:\DocSeva\docseva
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

---

## Security Principles

| Rule | Enforcement |
|------|-------------|
| Citizens access only their own data | Row Level Security (`auth.uid() = user_id`) |
| No service role key in frontend | Anon key only in client apps |
| Sensitive operations via backend | Supabase Edge Functions |
| OTP expiry + rate limiting | Supabase Auth built-in |

---

## Data Identity

```
auth.users.id (UUID)
      │
      └── profiles.id          (1:1)
      └── service_requests.user_id  (1:N)
      └── documents.user_id         (1:N)
```

Same UUID, same data — regardless of which app the citizen uses.

---

## Environment Variables

### Web (`janseva-web/.env.local`)
```
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

### Mobile (`--dart-define`)
```
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

> ⚠️ **Never** add `SUPABASE_SERVICE_ROLE_KEY` to any frontend environment.
> Use it only inside Supabase Edge Functions.

---

## Contributing

- Web and mobile codebases must **never import from each other**
- All shared logic lives in the Supabase backend (SQL functions, Edge Functions)
- New tables must have RLS enabled and appropriate policies
