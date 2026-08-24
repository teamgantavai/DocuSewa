import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';

// ---------------------------------------------------------------------------
// Environment variables
// ---------------------------------------------------------------------------
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

// ---------------------------------------------------------------------------
// Server client (for Server Components, Route Handlers, Server Actions)
// Reads/writes session from HTTP cookies — no manual token passing needed.
// ---------------------------------------------------------------------------
export async function createServerComponentClient() {
  const cookieStore = await cookies();

  return createServerClient(supabaseUrl, supabaseAnonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        } catch {
          // setAll called from Server Component — cookies are read-only.
          // Middleware handles refreshing the session.
        }
      },
    },
  });
}
