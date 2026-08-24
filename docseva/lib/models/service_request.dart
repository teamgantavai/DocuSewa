/// ServiceRequest — mirrors the `service_requests` table in Supabase.
class ServiceRequest {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final ServiceCategory category;
  final RequestStatus status;
  final RequestPriority priority;
  final String referenceNumber;
  final String? assignedProviderId;
  final DateTime? submittedAt;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceRequest({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.referenceNumber,
    this.assignedProviderId,
    this.submittedAt,
    this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: ServiceCategory.fromString(json['category'] as String? ?? 'general'),
      status: RequestStatus.fromString(json['status'] as String? ?? 'submitted'),
      priority: RequestPriority.fromString(json['priority'] as String? ?? 'normal'),
      referenceNumber: json['reference_number'] as String? ?? '',
      assignedProviderId: json['assigned_provider_id'] as String?,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  bool get isTerminal =>
      status == RequestStatus.completed ||
      status == RequestStatus.rejected ||
      status == RequestStatus.cancelled;
}

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

enum ServiceCategory {
  aadhaar('aadhaar', 'Aadhaar'),
  rationCard('ration_card', 'Ration Card'),
  incomeCertificate('income_certificate', 'Income Certificate'),
  property('property', 'Property'),
  pension('pension', 'Pension'),
  passport('passport', 'Passport'),
  drivingLicence('driving_licence', 'Driving Licence'),
  birthCertificate('birth_certificate', 'Birth Certificate'),
  deathCertificate('death_certificate', 'Death Certificate'),
  other('other', 'Other'),
  general('general', 'General');

  const ServiceCategory(this.value, this.label);
  final String value;
  final String label;

  static ServiceCategory fromString(String s) =>
      ServiceCategory.values.firstWhere((e) => e.value == s,
          orElse: () => ServiceCategory.general);
}

enum RequestStatus {
  draft('draft', 'Draft'),
  submitted('submitted', 'Submitted'),
  underReview('under_review', 'Under Review'),
  additionalInfoRequired('additional_info_required', 'Info Required'),
  approved('approved', 'Approved'),
  rejected('rejected', 'Rejected'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const RequestStatus(this.value, this.label);
  final String value;
  final String label;

  static RequestStatus fromString(String s) =>
      RequestStatus.values.firstWhere((e) => e.value == s,
          orElse: () => RequestStatus.submitted);
}

enum RequestPriority {
  low('low'),
  normal('normal'),
  high('high'),
  urgent('urgent');

  const RequestPriority(this.value);
  final String value;

  static RequestPriority fromString(String s) =>
      RequestPriority.values.firstWhere((e) => e.value == s,
          orElse: () => RequestPriority.normal);
}
