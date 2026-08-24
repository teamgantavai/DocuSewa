import { createClient } from '@/lib/supabase';
import type { CitizenProfile, UpdateProfileInput, ServiceResult } from '@/types/janseva';

// ---------------------------------------------------------------------------
// JanSeva Profile Service
//
// All queries are automatically scoped to the authenticated citizen via RLS.
// The anon key + user JWT = Supabase enforces auth.uid() = profiles.id.
// ---------------------------------------------------------------------------

/**
 * Fetch the authenticated citizen's profile.
 */
export async function getProfile(): Promise<ServiceResult<CitizenProfile>> {
  const supabase = createClient();

  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .single();

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: data as CitizenProfile, error: null };
}

/**
 * Get profile by user ID (only works for the authenticated citizen's own ID due to RLS).
 */
export async function getProfileById(
  userId: string
): Promise<ServiceResult<CitizenProfile>> {
  const supabase = createClient();

  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .single();

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: data as CitizenProfile, error: null };
}

/**
 * Update the authenticated citizen's profile.
 * Only permitted fields can be updated — account_type and account_status
 * are controlled by backend only (RLS enforces this).
 */
export async function updateProfile(
  input: UpdateProfileInput
): Promise<ServiceResult<CitizenProfile>> {
  const supabase = createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return { data: null, error: 'Not authenticated.' };
  }

  const { data, error } = await supabase
    .from('profiles')
    .update({
      full_name: input.full_name,
      display_name: input.display_name,
      email: input.email,
    })
    .eq('id', user.id)
    .select()
    .single();

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: data as CitizenProfile, error: null };
}

/**
 * Mark onboarding as complete.
 */
export async function completeOnboarding(
  userId: string
): Promise<ServiceResult<null>> {
  const supabase = createClient();

  const { error } = await supabase
    .from('profiles')
    .update({ is_new_user: false, onboarding_completed: true })
    .eq('id', userId);

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: null, error: null };
}

/**
 * Subscribe to real-time profile changes (e.g., account status updates).
 */
export function subscribeToProfile(
  userId: string,
  onUpdate: (profile: CitizenProfile) => void
) {
  const supabase = createClient();

  const channel = supabase
    .channel(`profile_${userId}`)
    .on(
      'postgres_changes',
      {
        event: 'UPDATE',
        schema: 'public',
        table: 'profiles',
        filter: `id=eq.${userId}`,
      },
      (payload) => {
        onUpdate(payload.new as CitizenProfile);
      }
    )
    .subscribe();

  return () => {
    supabase.removeChannel(channel);
  };
}
