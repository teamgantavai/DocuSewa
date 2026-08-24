# JanSeva Edge Functions

Supabase Edge Functions handle sensitive operations that require:
- The **service role key** (never exposed to frontend)
- Third-party API calls with private secrets
- Complex business logic that must not run in the browser

---

## When to Use Edge Functions

| Operation | Reason |
|---|---|
| Send custom SMS notifications | Requires Twilio/SMS secret |
| Verify a provider's credentials | Requires admin data access |
| Generate signed document URLs | Requires service role |
| Admin: suspend a citizen account | Bypasses RLS intentionally |
| Payment verification | Requires payment gateway secret |
| Bulk operations | Database-heavy, should not run in browser |

---

## Function Pattern

```typescript
// supabase/functions/verify-document/index.ts

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // 1. Extract the user's JWT from the Authorization header
  const authHeader = req.headers.get('Authorization')
  if (!authHeader) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401 })
  }

  // 2. Create a Supabase client using the SERVICE ROLE key
  //    This bypasses RLS — validate the caller's identity first!
  const supabaseAdmin = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!  // NEVER in frontend code
  )

  // 3. Verify the caller's JWT to get their user_id
  const supabaseUser = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: authHeader } } }
  )
  const { data: { user }, error } = await supabaseUser.auth.getUser()
  if (error || !user) {
    return new Response(JSON.stringify({ error: 'Invalid token' }), { status: 401 })
  }

  // 4. Check that the caller is authorized for this operation
  const { data: profile } = await supabaseAdmin
    .from('profiles')
    .select('account_type')
    .eq('id', user.id)
    .single()

  if (profile?.account_type !== 'provider') {
    return new Response(JSON.stringify({ error: 'Forbidden' }), { status: 403 })
  }

  // 5. Perform the sensitive operation
  const body = await req.json()
  await supabaseAdmin
    .from('documents')
    .update({ verification_status: 'verified', verified_at: new Date().toISOString() })
    .eq('id', body.document_id)

  return new Response(JSON.stringify({ success: true }), { status: 200 })
})
```

---

## Deploying Edge Functions

```sh
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Deploy a function
supabase functions deploy verify-document

# Set secrets (never hardcode in function files)
supabase secrets set TWILIO_AUTH_TOKEN=your-secret
```

---

## Planned Functions

| Function Name | Trigger | Purpose |
|---|---|---|
| `on-user-signup` | Auth webhook | Send welcome SMS |
| `verify-document` | HTTP POST | Mark document verified (provider only) |
| `notify-status-change` | DB webhook | Send SMS when request status changes |
| `generate-document-url` | HTTP POST | Create time-limited signed storage URL |

---

## Security Checklist

- [ ] Every function validates `Authorization` header first
- [ ] Every function checks the caller's `account_type` before admin actions
- [ ] Service role key set as Supabase secret, never in code
- [ ] All third-party API keys set as Supabase secrets
- [ ] Functions return minimal data (no leaking other users' info)
