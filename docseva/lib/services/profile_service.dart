import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:docusewa/core/supabase_client.dart';
import 'package:docusewa/models/citizen_profile.dart';

/// DocuSewa Profile Service.
/// All queries auto-scoped to authenticated citizen by Supabase RLS.
class ProfileService {
  ProfileService._();
  static final ProfileService instance = ProfileService._();

  /// Fetch the authenticated citizen's profile.
  Future<CitizenProfile?> getProfile() async {
    try {
      final data = await DocuSewaSupabase.client
          .from('profiles')
          .select()
          .single();
      return CitizenProfile.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Update permitted profile fields.
  Future<CitizenProfile?> updateProfile({
    String? fullName,
    String? displayName,
    String? email,
  }) async {
    try {
      final userId = DocuSewaSupabase.currentUserId;
      if (userId == null) return null;

      final data = await DocuSewaSupabase.client
          .from('profiles')
          .update({
            'full_name': ?fullName,
            'display_name': ?displayName,
            'email': ?email,
          })
          .eq('id', userId)
          .select()
          .single();
      return CitizenProfile.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Mark onboarding complete.
  Future<void> completeOnboarding() async {
    final userId = DocuSewaSupabase.currentUserId;
    if (userId == null) return;
    await DocuSewaSupabase.client
        .from('profiles')
        .update({'is_new_user': false, 'onboarding_completed': true})
        .eq('id', userId);
  }

  /// Subscribe to real-time profile updates.
  /// Returns an unsubscribe function.
  Future<void> Function() subscribeToProfile(
    String userId,
    void Function(CitizenProfile) onUpdate,
  ) {
    final channel = DocuSewaSupabase.client
        .channel('profile_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'profiles',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (payload) {
            try {
              onUpdate(CitizenProfile.fromJson(payload.newRecord));
            } catch (_) {}
          },
        )
        .subscribe();

    return () async {
      await DocuSewaSupabase.client.removeChannel(channel);
    };
  }
}
