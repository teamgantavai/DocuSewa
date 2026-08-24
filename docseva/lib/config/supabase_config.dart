/// DocuSewa Supabase Configuration
///
/// IMPORTANT: Never commit real keys to version control.
/// Set these via environment variables or a secure secrets manager.
///
/// For Supabase phone OTP auth, enable Phone provider in:
/// Supabase Dashboard → Authentication → Providers → Phone
///
/// Then configure your Twilio/MessageBird SMS credentials in
/// Supabase Dashboard → Authentication → SMS Templates
class SupabaseConfig {
  SupabaseConfig._();

  /// Your Supabase project URL
  /// Set via --dart-define=SUPABASE_URL=https://yourproject.supabase.co
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  /// Your Supabase anon (public) key — safe to embed in client apps
  /// Set via --dart-define=SUPABASE_ANON_KEY=your-anon-key
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-supabase-anon-key',
  );

  /// OTP expiry in seconds (should match Supabase configuration)
  static const int otpExpirySeconds = 300; // 5 minutes

  /// Resend cooldown in seconds
  static const int resendCooldownSeconds = 30;

  /// Maximum incorrect OTP attempts before rate-limit lock
  static const int maxOtpAttempts = 3;
}
