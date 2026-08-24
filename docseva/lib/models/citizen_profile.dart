/// CitizenProfile — mirrors the `profiles` table in Supabase.
/// Same structure as the TypeScript type in janseva-web/src/types/janseva.ts
class CitizenProfile {
  final String id;
  final String? phone;
  final String? email;
  final String? fullName;
  final String? displayName;
  final AccountType accountType;
  final AccountStatus accountStatus;
  final bool isNewUser;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CitizenProfile({
    required this.id,
    this.phone,
    this.email,
    this.fullName,
    this.displayName,
    required this.accountType,
    required this.accountStatus,
    required this.isNewUser,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CitizenProfile.fromJson(Map<String, dynamic> json) {
    return CitizenProfile(
      id: json['id'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      displayName: json['display_name'] as String?,
      accountType: AccountType.fromString(json['account_type'] as String? ?? 'citizen'),
      accountStatus: AccountStatus.fromString(json['account_status'] as String? ?? 'active'),
      isNewUser: json['is_new_user'] as bool? ?? true,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'email': email,
        'full_name': fullName,
        'display_name': displayName,
        'account_type': accountType.value,
        'account_status': accountStatus.value,
        'is_new_user': isNewUser,
        'onboarding_completed': onboardingCompleted,
      };

  /// Masked phone for display: +91 98765 43210
  String get maskedPhone {
    final p = phone ?? '';
    if (p.length == 10) {
      return '+91 ${p.substring(0, 5)} ${p.substring(5)}';
    }
    return '+91 $p';
  }

  /// Display name fallback chain
  String get bestName =>
      displayName ?? fullName ?? 'DocuSewa Citizen';

  CitizenProfile copyWith({
    String? fullName,
    String? displayName,
    String? email,
    bool? isNewUser,
    bool? onboardingCompleted,
  }) {
    return CitizenProfile(
      id: id,
      phone: phone,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      displayName: displayName ?? this.displayName,
      accountType: accountType,
      accountStatus: accountStatus,
      isNewUser: isNewUser ?? this.isNewUser,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

enum AccountType {
  citizen('citizen'),
  provider('provider'),
  admin('admin');

  const AccountType(this.value);
  final String value;

  static AccountType fromString(String s) =>
      AccountType.values.firstWhere((e) => e.value == s,
          orElse: () => AccountType.citizen);
}

enum AccountStatus {
  active('active'),
  suspended('suspended'),
  pendingVerification('pending_verification');

  const AccountStatus(this.value);
  final String value;

  static AccountStatus fromString(String s) =>
      AccountStatus.values.firstWhere((e) => e.value == s,
          orElse: () => AccountStatus.active);
}
