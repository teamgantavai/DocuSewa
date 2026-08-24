import { createClient } from '@/lib/supabase';
import type {
  ServiceRequest,
  CreateServiceRequestInput,
  ServiceResult,
  RequestStatus,
} from '@/types/janseva';

// ---------------------------------------------------------------------------
// JanSeva Service Request Service
//
// RLS automatically scopes all queries to the authenticated citizen.
// A citizen created via Flutter and accessing via web gets the SAME requests.
// ---------------------------------------------------------------------------

/**
 * Fetch all service requests for the authenticated citizen.
 * Sorted newest first. RLS ensures only own requests are returned.
 */
export async function getRequests(): Promise<ServiceResult<ServiceRequest[]>> {
  const supabase = createClient();

  const { data, error } = await supabase
    .from('service_requests')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: data as ServiceRequest[], error: null };
}

/**
 * Fetch a single service request by ID (RLS ensures ownership).
 */
export async function getRequestById(
  id: string
): Promise<ServiceResult<ServiceRequest>> {
  const supabase = createClient();

  const { data, error } = await supabase
    .from('service_requests')
    .select('*')
    .eq('id', id)
    .single();

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: data as ServiceRequest, error: null };
}

/**
 * Create a new service request.
 * user_id is set from auth.uid() by RLS policy (insert check).
 */
export async function createRequest(
  input: CreateServiceRequestInput
): Promise<ServiceResult<ServiceRequest>> {
  const supabase = createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return { data: null, error: 'Not authenticated.' };
  }

  const { data, error } = await supabase
    .from('service_requests')
    .insert({
      user_id: user.id,          // enforced by RLS insert check too
      title: input.title,
      description: input.description ?? null,
      category: input.category,
      priority: input.priority ?? 'normal',
      status: 'submitted',       // new requests go straight to submitted
    })
    .select()
    .single();

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: data as ServiceRequest, error: null };
}

/**
 * Cancel a citizen's own request (status must not already be terminal).
 */
export async function cancelRequest(
  id: string
): Promise<ServiceResult<null>> {
  const supabase = createClient();

  const { error } = await supabase
    .from('service_requests')
    .update({ status: 'cancelled' as RequestStatus })
    .eq('id', id)
    .in('status', ['draft', 'submitted', 'under_review', 'additional_info_required']);

  if (error) {
    return { data: null, error: error.message };
  }

  return { data: null, error: null };
}

/**
 * Subscribe to real-time status changes on the citizen's requests.
 * Works across web and mobile — same Supabase channel.
 */
export function subscribeToRequestUpdates(
  userId: string,
  onUpdate: (request: ServiceRequest) => void
) {
  const supabase = createClient();

  const channel = supabase
    .channel(`service_requests_${userId}`)
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'service_requests',
        filter: `user_id=eq.${userId}`,
      },
      (payload) => {
        if (payload.new) {
          onUpdate(payload.new as ServiceRequest);
        }
      }
    )
    .subscribe();

  return () => {
    supabase.removeChannel(channel);
  };
}
