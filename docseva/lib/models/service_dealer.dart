/// ServiceDealer — Model for verified government service providers / CSC / Jan Seva Kendra operators.
class ServiceDealer {
  final String id;
  final String name;
  final String operatorName;
  final String authCertNumber; // e.g. "CSC-ID: DL-884920"
  final String centerType; // e.g. "CSC Center", "Jan Seva Kendra", "e-Mitra", "Authorized Citizen Point"
  final bool isVerified;
  final bool isCurrentlyActive;
  final double latitude;
  final double longitude;
  final String address;
  final String locality;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final String email;
  final double rating; // 1.0 - 5.0
  final int reviewCount;
  final int totalServicesCompleted;
  final int avgResponseMinutes;
  final double reliabilityScore; // 0 - 100
  final double cancellationRate; // e.g. 0.5%
  final bool documentSafetyCompliant;
  final List<String> supportedServiceIds; // specific service IDs or category wildcard
  final Map<String, int> servicePricing; // serviceId -> fee in INR
  final List<String> badges;
  final String workingHours;

  const ServiceDealer({
    required this.id,
    required this.name,
    required this.operatorName,
    required this.authCertNumber,
    required this.centerType,
    required this.isVerified,
    required this.isCurrentlyActive,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.locality,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    required this.email,
    required this.rating,
    required this.reviewCount,
    required this.totalServicesCompleted,
    required this.avgResponseMinutes,
    required this.reliabilityScore,
    required this.cancellationRate,
    required this.documentSafetyCompliant,
    required this.supportedServiceIds,
    required this.servicePricing,
    required this.badges,
    this.workingHours = '9:00 AM - 7:00 PM (Mon-Sat)',
  });

  /// Check if dealer supports the specific service ID or category
  bool supportsService(String serviceId, {String? category}) {
    if (supportedServiceIds.contains('*') || supportedServiceIds.contains(serviceId)) {
      return true;
    }
    if (category != null && supportedServiceIds.contains('cat:$category')) {
      return true;
    }
    return false;
  }

  /// Get pricing for service or standard default
  int getFeeForService(String serviceId) {
    if (servicePricing.containsKey(serviceId)) {
      return servicePricing[serviceId]!;
    }
    if (servicePricing.containsKey('default')) {
      return servicePricing['default']!;
    }
    return 50; // Standard nominal government CSC fee
  }
}

/// Recommendation result holding computed multi-factor score and breakdown
class DealerRecommendation {
  final ServiceDealer dealer;
  final double distanceKm;
  final double smartScore; // 0 - 100
  final Map<String, double> scoreBreakdown; // component -> score
  final List<String> matchHighlights;
  final String primaryReason;

  const DealerRecommendation({
    required this.dealer,
    required this.distanceKm,
    required this.smartScore,
    required this.scoreBreakdown,
    required this.matchHighlights,
    required this.primaryReason,
  });
}
