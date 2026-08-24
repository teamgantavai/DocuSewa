import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:docusewa/config/env.dart';

/// Singleton Supabase client for DocuSewa mobile app.
///
/// Initialise once at app startup via [DocuSewaSupabase.initialize()].
/// Access the client anywhere via [DocuSewaSupabase.client].
class DocuSewaSupabase {
  DocuSewaSupabase._();

  /// Call this in [main()] before [runApp()].
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: DocuSewaEnv.supabaseUrl,
      publishableKey: DocuSewaEnv.supabaseAnonKey,
    );
  }

  /// Access the Supabase client after [initialize()] has been called.
  static SupabaseClient get client => Supabase.instance.client;

  /// Convenience: get the authenticated user's ID, or null.
  static String? get currentUserId =>
      Supabase.instance.client.auth.currentUser?.id;

  /// True if a citizen is currently signed in.
  static bool get isAuthenticated =>
      Supabase.instance.client.auth.currentSession != null;
}

/// Backwards compatibility alias
typedef JanSevaSupabase = DocuSewaSupabase;


