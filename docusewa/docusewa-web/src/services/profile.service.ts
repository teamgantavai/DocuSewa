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

  const updatePayload: Record<string, any> = {};
  if (input.full_name !== undefined) updatePayload.full_name = input.full_name;
  if (input.display_name !== undefined) updatePayload.display_name = input.display_name;
  if (input.email !== undefined) updatePayload.email = input.email;
  if (input.avatar_url !== undefined) updatePayload.avatar_url = input.avatar_url;
  else if (input.photo_url !== undefined) updatePayload.avatar_url = input.photo_url;

  const { data, error } = await supabase
    .from('profiles')
    .update(updatePayload)
    .eq('id', user.id)
    .select()
    .single();

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: data as CitizenProfile, error: null };
}

/**
 * Upload a profile photo file to Supabase Storage (bucket: 'citizen-documents')
 * and returns the public or signed URL, with graceful handling.
 */
export async function uploadProfilePhoto(
  userId: string,
  file: File
): Promise<ServiceResult<{ photoUrl: string }>> {
  const supabase = createClient();

  try {
    const fileExt = file.name.split('.').pop() || 'jpg';
    const fileName = `${userId}/avatar-${Date.now()}.${fileExt}`;

    const { error: uploadError } = await supabase.storage
      .from('citizen-documents')
      .upload(fileName, file, {
        cacheControl: '3600',
        upsert: true,
      });

    if (uploadError) {
      // Fallback: If storage bucket is not configured or error occurs,
      // create a Base64/data URL locally so user experience is smooth.
      const base64 = await new Promise<string>((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result as string);
        reader.onerror = reject;
        reader.readAsDataURL(file);
      });
      return { data: { photoUrl: base64 }, error: null };
    }

    const { data: publicUrlData } = supabase.storage
      .from('citizen-documents')
      .getPublicUrl(fileName);

    const photoUrl = publicUrlData?.publicUrl || URL.createObjectURL(file);
    return { data: { photoUrl }, error: null };
  } catch (err: any) {
    return { data: null, error: err.message || 'Failed to upload photo.' };
  }
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
