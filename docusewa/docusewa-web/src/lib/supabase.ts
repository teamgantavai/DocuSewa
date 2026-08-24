import { createBrowserClient } from '@supabase/ssr';

// ---------------------------------------------------------------------------
// Environment variables
// ---------------------------------------------------------------------------
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

if (!supabaseUrl || !supabaseAnonKey) {
  // During build or before setup, warn rather than crash completely if env is missing
  if (typeof window !== 'undefined') {
    console.warn(
      'Missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY. ' +
        'Copy .env.local.example to .env.local and fill in your Supabase credentials.'
    );
  }
}

// ---------------------------------------------------------------------------
// Browser client (for Client Components — 'use client')
// ---------------------------------------------------------------------------
export function createClient() {
  return createBrowserClient(supabaseUrl || '', supabaseAnonKey || '');
}
