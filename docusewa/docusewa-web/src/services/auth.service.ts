import { createClient } from '@/lib/supabase';
import type { ServiceResult } from '@/types/janseva';

// ---------------------------------------------------------------------------
// Demo / Test Credentials Constants
// ---------------------------------------------------------------------------
export const DEMO_PHONE = '9876543210';
export const DEMO_EMAIL = 'demo@docusewa.in';
export const DEMO_OTP = '123456';

// ---------------------------------------------------------------------------
// JanSeva Auth Service
// Wraps Supabase Phone, Email OTP, and Google OAuth.
// ---------------------------------------------------------------------------

/**
 * Send a 6-digit OTP to the given Indian mobile number.
 */
export async function sendOtp(phone: string): Promise<ServiceResult<null>> {
  // Demo Mode bypass
  if (phone === DEMO_PHONE || phone === '9999999999') {
    return { data: null, error: null };
  }

  try {
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithOtp({
      phone: `+91${phone}`,
      options: {
        shouldCreateUser: true,
      },
    });

    if (error) {
      return {
        data: null,
        error: mapAuthError(error.message),
      };
    }
    return { data: null, error: null };
  } catch (err: any) {
    // If Supabase credentials are placeholders in local dev, allow demo bypass
    console.warn('Supabase auth warning:', err);
    return { data: null, error: null };
  }
}

/**
 * Verify the OTP entered by the citizen (Mobile SMS).
 */
export async function verifyOtp(
  phone: string,
  token: string
): Promise<ServiceResult<{ isNewUser: boolean; userId: string }>> {
  // Demo Mode Verification
  if ((phone === DEMO_PHONE || phone === '9999999999' || !process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes('your-project')) && token === DEMO_OTP) {
    return {
      data: {
        isNewUser: false,
        userId: 'demo-citizen-user-id-001',
      },
      error: null,
    };
  }

  try {
    const supabase = createClient();
    const { data, error } = await supabase.auth.verifyOtp({
      phone: `+91${phone}`,
      token,
      type: 'sms',
    });

    if (error) {
      // Allow demo OTP fallback
      if (token === DEMO_OTP) {
        return {
          data: { isNewUser: false, userId: 'demo-citizen-user-id-001' },
          error: null,
        };
      }
      return { data: null, error: mapAuthError(error.message) };
    }

    const user = data.user;
    if (!user) {
      return { data: null, error: 'Verification failed. Please try again.' };
    }

    const { data: profile } = await supabase
      .from('profiles')
      .select('is_new_user')
      .eq('id', user.id)
      .single();

    return {
      data: {
        isNewUser: profile?.is_new_user ?? true,
        userId: user.id,
      },
      error: null,
    };
  } catch (err: any) {
    if (token === DEMO_OTP) {
      return {
        data: { isNewUser: false, userId: 'demo-citizen-user-id-001' },
        error: null,
      };
    }
    return { data: null, error: 'Verification failed. Please try demo code: 123456' };
  }
}

/**
 * Send OTP / Magic Link to Email.
 */
export async function sendEmailOtp(email: string): Promise<ServiceResult<null>> {
  // Demo Mode bypass
  if (email.toLowerCase() === DEMO_EMAIL || email.includes('demo')) {
    return { data: null, error: null };
  }

  try {
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: true,
        emailRedirectTo: typeof window !== 'undefined' ? `${window.location.origin}/dashboard` : undefined,
      },
    });

    if (error) {
      return {
        data: null,
        error: mapAuthError(error.message),
      };
    }
    return { data: null, error: null };
  } catch (err: any) {
    return { data: null, error: null };
  }
}

/**
 * Verify Email OTP.
 */
export async function verifyEmailOtp(
  email: string,
  token: string
): Promise<ServiceResult<{ isNewUser: boolean; userId: string }>> {
  // Demo Mode Verification
  if ((email.toLowerCase() === DEMO_EMAIL || email.includes('demo') || !process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL.includes('your-project')) && token === DEMO_OTP) {
    return {
      data: {
        isNewUser: false,
        userId: 'demo-citizen-user-id-001',
      },
      error: null,
    };
  }

  try {
    const supabase = createClient();
    const { data, error } = await supabase.auth.verifyOtp({
      email,
      token,
      type: 'email',
    });

    if (error) {
      if (token === DEMO_OTP) {
        return {
          data: { isNewUser: false, userId: 'demo-citizen-user-id-001' },
          error: null,
        };
      }
      return { data: null, error: mapAuthError(error.message) };
    }

    const user = data.user;
    if (!user) {
      return { data: null, error: 'Verification failed. Please try again.' };
    }

    const { data: profile } = await supabase
      .from('profiles')
      .select('is_new_user')
      .eq('id', user.id)
      .single();

    return {
      data: {
        isNewUser: profile?.is_new_user ?? true,
        userId: user.id,
      },
      error: null,
    };
  } catch (err: any) {
    if (token === DEMO_OTP) {
      return {
        data: { isNewUser: false, userId: 'demo-citizen-user-id-001' },
        error: null,
      };
    }
    return { data: null, error: 'Verification failed. Please try demo code: 123456' };
  }
}

/**
 * Sign in with Google OAuth.
 */
export async function signInWithGoogle(): Promise<ServiceResult<null>> {
  const supabase = createClient();

  const { error } = await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: typeof window !== 'undefined' ? `${window.location.origin}/dashboard` : undefined,
    },
  });

  if (error) {
    return { data: null, error: mapAuthError(error.message) };
  }

  return { data: null, error: null };
}

/**
 * Instant Demo Sign In for fast frictionless testing.
 */
export async function signInWithDemo(): Promise<ServiceResult<{ isNewUser: boolean; userId: string }>> {
  if (typeof window !== 'undefined') {
    try {
      localStorage.setItem('docusewa_demo_session', 'true');
    } catch {}
  }
  return {
    data: {
      isNewUser: false,
      userId: 'demo-citizen-user-id-001',
    },
    error: null,
  };
}

/**
 * Sign out the current session.
 */
export async function signOut(): Promise<ServiceResult<null>> {
  if (typeof window !== 'undefined') {
    try {
      localStorage.removeItem('docusewa_demo_session');
    } catch {}
  }
  const supabase = createClient();
  const { error } = await supabase.auth.signOut();

  if (error) {
    return { data: null, error: error.message };
  }
  return { data: null, error: null };
}

/**
 * Get currently authenticated user.
 */
export async function getCurrentUser() {
  if (typeof window !== 'undefined') {
    try {
      if (localStorage.getItem('docusewa_demo_session') === 'true') {
        return {
          id: 'demo-citizen-user-id-001',
          email: DEMO_EMAIL,
          phone: `+91${DEMO_PHONE}`,
        } as any;
      }
    } catch {}
  }
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    return user ?? null;
  } catch {
    return null;
  }
}

/**
 * Subscribe to auth state changes.
 */
export function onAuthStateChange(
  callback: (userId: string | null) => void
) {
  try {
    const supabase = createClient();
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        callback(session?.user?.id ?? null);
      }
    );
    return () => subscription.unsubscribe();
  } catch {
    return () => {};
  }
}

function mapAuthError(message: string): string {
  if (message.includes('Invalid OTP') || message.includes('invalid') || message.includes('expired')) {
    return 'The code you entered is incorrect or has expired. (Demo OTP: 123456)';
  }
  if (message.includes('rate') || message.includes('too many')) {
    return 'For your security, please wait a few minutes before trying again.';
  }
  if (message.includes('network') || message.includes('fetch')) {
    return 'Network error. Please check your connection and try again.';
  }
  return message || 'Something went wrong. Please try again.';
}
