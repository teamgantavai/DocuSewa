/// DocuSewa environment configuration.
///
/// Pass credentials at build time via --dart-define:
///
///   flutter run \
///     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=your-anon-key
///
/// For VS Code, add to .vscode/launch.json:
///   "toolArgs": [
///     "--dart-define=SUPABASE_URL=...",
///     "--dart-define=SUPABASE_ANON_KEY=..."
///   ]
///
/// NEVER hardcode the service role key here.
class DocuSewaEnv {
  DocuSewaEnv._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-supabase-anon-key',
  );

  /// OTP resend cooldown in seconds (match Supabase config)
  static const int resendCooldownSeconds = 30;

  /// Maximum failed OTP attempts before lock message
  static const int maxOtpAttempts = 3;

  /// OTP validity window in seconds
  static const int otpExpirySeconds = 300;
}

/// Backwards compatibility alias
typedef JanSevaEnv = DocuSewaEnv;

