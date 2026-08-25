// JanSeva TypeScript type definitions
// These mirror the PostgreSQL schema defined in backend/supabase/migrations/

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

export type AccountType = 'citizen' | 'provider' | 'admin';

export type AccountStatus = 'active' | 'suspended' | 'pending_verification';

export type ServiceCategory =
  | 'aadhaar'
  | 'ration_card'
  | 'income_certificate'
  | 'property'
  | 'pension'
  | 'passport'
  | 'driving_licence'
  | 'birth_certificate'
  | 'death_certificate'
  | 'other'
  | 'general';

export type RequestStatus =
  | 'draft'
  | 'submitted'
  | 'under_review'
  | 'additional_info_required'
  | 'approved'
  | 'rejected'
  | 'completed'
  | 'cancelled';

export type RequestPriority = 'low' | 'normal' | 'high' | 'urgent';

export type DocumentType =
  | 'aadhaar'
  | 'pan'
  | 'passport'
  | 'driving_licence'
  | 'ration_card'
  | 'voter_id'
  | 'income_certificate'
  | 'birth_certificate'
  | 'death_certificate'
  | 'property_deed'
  | 'utility_bill'
  | 'photograph'
  | 'signature'
  | 'other';

export type VerificationStatus =
  | 'unverified'
  | 'pending_review'
  | 'verified'
  | 'rejected';

// ---------------------------------------------------------------------------
// Database row types
// ---------------------------------------------------------------------------

export interface CitizenProfile {
  id: string;
  phone: string | null;
  email: string | null;
  full_name: string | null;
  display_name: string | null;
  avatar_url?: string | null;
  account_type: AccountType;
  account_status: AccountStatus;
  is_new_user: boolean;
  onboarding_completed: boolean;
  created_at: string;
  updated_at: string;
}

export interface ServiceRequest {
  id: string;
  user_id: string;
  title: string;
  description: string | null;
  category: ServiceCategory;
  status: RequestStatus;
  priority: RequestPriority;
  reference_number: string;
  assigned_provider_id: string | null;
  submitted_at: string | null;
  resolved_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface Document {
  id: string;
  user_id: string;
  service_request_id: string | null;
  name: string;
  original_filename: string;
  mime_type: string | null;
  file_size_bytes: number | null;
  storage_path: string;
  document_type: DocumentType;
  verification_status: VerificationStatus;
  uploaded_at: string;
  verified_at: string | null;
  expires_at: string | null;
  created_at: string;
  updated_at: string;
}

// ---------------------------------------------------------------------------
// Form / UI types
// ---------------------------------------------------------------------------

export interface CreateServiceRequestInput {
  title: string;
  description?: string;
  category: ServiceCategory;
  priority?: RequestPriority;
}

export interface UpdateProfileInput {
  full_name?: string;
  display_name?: string;
  email?: string;
  avatar_url?: string | null;
  photo_url?: string | null;
}

// ---------------------------------------------------------------------------
// Auth state
// ---------------------------------------------------------------------------

export interface AuthState {
  userId: string | null;
  phone: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
}

// ---------------------------------------------------------------------------
// API response wrappers
// ---------------------------------------------------------------------------

export interface ServiceResult<T> {
  data: T | null;
  error: string | null;
}

// ---------------------------------------------------------------------------
// Status display helpers
// ---------------------------------------------------------------------------

export const statusLabels: Record<RequestStatus, string> = {
  draft: 'Draft',
  submitted: 'Submitted',
  under_review: 'Under Review',
  additional_info_required: 'Info Required',
  approved: 'Approved',
  rejected: 'Rejected',
  completed: 'Completed',
  cancelled: 'Cancelled',
};

export const categoryLabels: Record<ServiceCategory, string> = {
  aadhaar: 'Aadhaar',
  ration_card: 'Ration Card',
  income_certificate: 'Income Certificate',
  property: 'Property',
  pension: 'Pension',
  passport: 'Passport',
  driving_licence: 'Driving Licence',
  birth_certificate: 'Birth Certificate',
  death_certificate: 'Death Certificate',
  other: 'Other',
  general: 'General',
};

export const statusColors: Record<RequestStatus, string> = {
  draft: '#94A3B8',
  submitted: '#2563EB',
  under_review: '#F59E0B',
  additional_info_required: '#EF4444',
  approved: '#16A34A',
  rejected: '#DC2626',
  completed: '#059669',
  cancelled: '#6B7280',
};
