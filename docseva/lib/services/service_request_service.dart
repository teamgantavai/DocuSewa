import 'package:docusewa/core/supabase_client.dart';
import 'package:docusewa/models/service_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// DocuSewa Service Request Service.
/// RLS auto-scopes all queries to the authenticated citizen.
class ServiceRequestService {
  ServiceRequestService._();
  static final ServiceRequestService instance = ServiceRequestService._();

  /// Fetch all service requests for the authenticated citizen, newest first.
  Future<List<ServiceRequest>> getRequests() async {
    try {
      final data = await DocuSewaSupabase.client
          .from('service_requests')
          .select()
          .order('created_at', ascending: false);
      return (data as List).map((e) => ServiceRequest.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetch a single service request by ID (RLS ensures ownership).
  Future<ServiceRequest?> getRequestById(String id) async {
    try {
      final data = await DocuSewaSupabase.client
          .from('service_requests')
          .select()
          .eq('id', id)
          .single();
      return ServiceRequest.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Create a new service request.
  Future<ServiceRequest?> createRequest({
    required String title,
    String? description,
    required ServiceCategory category,
    RequestPriority priority = RequestPriority.normal,
  }) async {
    try {
      final userId = DocuSewaSupabase.currentUserId;
      if (userId == null) return null;

      final data = await DocuSewaSupabase.client
          .from('service_requests')
          .insert({
            'user_id': userId,
            'title': title,
            'description': description,
            'category': category.value,
            'priority': priority.value,
            'status': 'submitted',
          })
          .select()
          .single();
      return ServiceRequest.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Cancel a request (only non-terminal requests can be cancelled).
  Future<bool> cancelRequest(String id) async {
    try {
      await DocuSewaSupabase.client
          .from('service_requests')
          .update({'status': 'cancelled'})
          .eq('id', id)
          .inFilter('status', ['draft', 'submitted', 'under_review', 'additional_info_required']);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Subscribe to real-time updates on the citizen's requests.
  /// Returns an unsubscribe function.
  Future<void> Function() subscribeToRequests(
    String userId,
    void Function(ServiceRequest) onUpdate,
  ) {
    final channel = DocuSewaSupabase.client
        .channel('service_requests_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'service_requests',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            try {
              if (payload.newRecord.isNotEmpty) {
                onUpdate(ServiceRequest.fromJson(payload.newRecord));
              }
            } catch (_) {}
          },
        )
        .subscribe();

    return () async {
      await DocuSewaSupabase.client.removeChannel(channel);
    };
  }
}
