import 'dart:math' as math;
import 'package:docusewa/models/service_dealer.dart';
import 'package:docusewa/screens/home_screen.dart' show ServiceData;
import 'package:docusewa/services/user_location_service.dart';

/// Seed list of verified government service operators (CSCs, Jan Seva Kendras, etc.)
final List<ServiceDealer> kVerifiedDealersDatabase = [
  // --- NOIDA / NCR REGION (Sector 62 / 63 / Indirapuram) ---
  const ServiceDealer(
    id: 'csc_noida_sec62',
    name: 'Digital Seva Kendra — Sector 62',
    operatorName: 'Rameshwar Sharma (Certified VLE)',
    authCertNumber: 'CSC-ID: UP-NOI-88492',
    centerType: 'CSC Common Service Center',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 28.6288,
    longitude: 77.3658,
    address: 'Shop 14, Ground Floor, B-Block Market, Sector 62',
    locality: 'Sector 62',
    city: 'Noida',
    state: 'Uttar Pradesh',
    pincode: '201301',
    phone: '+91 98182 44102',
    email: 'csc.sec62noida@docusewa.gov.in',
    rating: 4.92,
    reviewCount: 438,
    totalServicesCompleted: 2340,
    avgResponseMinutes: 11,
    reliabilityScore: 99.4,
    cancellationRate: 0.3,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'], // Supports all services
    servicePricing: {
      'pan-card': 50,
      'aadhaar-update': 50,
      'driving-licence': 70,
      'ration-card': 50,
      'income-certificate': 60,
      'caste-certificate': 60,
      'default': 50,
    },
    badges: ['Top Recommended', 'Govt Certified', 'Fast Response', 'Doorstep Token'],
    workingHours: '8:30 AM - 8:00 PM (All 7 Days)',
  ),

  const ServiceDealer(
    id: 'jsk_noida_sec63',
    name: 'Jan Seva Kendra & e-District Hub',
    operatorName: 'Priya Verma (Authorized Officer)',
    authCertNumber: 'JSK-UP-80129',
    centerType: 'Jan Seva Kendra',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 28.6340,
    longitude: 77.3780,
    address: 'Plot 28, Electronic City Metro Gate 3, Sector 63',
    locality: 'Sector 63',
    city: 'Noida',
    state: 'Uttar Pradesh',
    pincode: '201301',
    phone: '+91 98711 20984',
    email: 'jsk.sec63@docusewa.gov.in',
    rating: 4.88,
    reviewCount: 312,
    totalServicesCompleted: 1890,
    avgResponseMinutes: 14,
    reliabilityScore: 98.6,
    cancellationRate: 0.6,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'aadhaar-update': 40,
      'driving-licence': 60,
      'income-certificate': 50,
      'default': 50,
    },
    badges: ['Govt Certified', 'DigiLocker Verified', 'Biometric Ready'],
    workingHours: '9:00 AM - 7:30 PM (Mon-Sat)',
  ),

  const ServiceDealer(
    id: 'csc_indirapuram_01',
    name: 'Apex Citizen Facilitation Point',
    operatorName: 'Amit Saxena (Certified VLE)',
    authCertNumber: 'CSC-ID: UP-GZB-44190',
    centerType: 'CSC Common Service Center',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 28.6410,
    longitude: 77.3725,
    address: 'Shop 8, Windsor Street Market, Vaibhav Khand, Indirapuram',
    locality: 'Indirapuram',
    city: 'Ghaziabad',
    state: 'Uttar Pradesh',
    pincode: '201014',
    phone: '+91 99100 55421',
    email: 'apex.indirapuram@docusewa.gov.in',
    rating: 4.85,
    reviewCount: 275,
    totalServicesCompleted: 1420,
    avgResponseMinutes: 16,
    reliabilityScore: 97.8,
    cancellationRate: 0.9,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 60,
      'aadhaar-update': 50,
      'driving-licence': 80,
      'default': 50,
    },
    badges: ['Govt Certified', 'Express Filing'],
    workingHours: '9:30 AM - 7:00 PM (Mon-Sat)',
  ),

  const ServiceDealer(
    id: 'csc_noida_sec59',
    name: 'Shree Sai e-Governance & Aadhaar Center',
    operatorName: 'Sunil Kumar (Master Operator)',
    authCertNumber: 'UIDAI-CSC: UP-99014',
    centerType: 'Authorized Citizen Agent',
    isVerified: true,
    isCurrentlyActive: false, // Closed for lunch / night
    latitude: 28.6050,
    longitude: 77.3620,
    address: 'Near Metro Station Pillar 104, Sector 59',
    locality: 'Sector 59',
    city: 'Noida',
    state: 'Uttar Pradesh',
    pincode: '201301',
    phone: '+91 97180 33214',
    email: 'shreesai.sec59@docusewa.gov.in',
    rating: 4.79,
    reviewCount: 198,
    totalServicesCompleted: 980,
    avgResponseMinutes: 24,
    reliabilityScore: 96.2,
    cancellationRate: 1.2,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'aadhaar-update': 50,
      'default': 50,
    },
    badges: ['Govt Certified', 'UIDAI Registered'],
    workingHours: '10:00 AM - 6:30 PM (Mon-Fri)',
  ),

  // --- NEW DELHI CENTRAL (Connaught Place / Karol Bagh / Mandi House) ---
  const ServiceDealer(
    id: 'csc_delhi_cp',
    name: 'Central Delhi e-Sewa Kendra — Connaught Place',
    operatorName: 'Harish Chander (Sr. VLE)',
    authCertNumber: 'CSC-ID: DL-ND-10492',
    centerType: 'CSC Common Service Center',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 28.6320,
    longitude: 77.2180,
    address: 'Block E, 2nd Floor, Inner Circle, Connaught Place',
    locality: 'Connaught Place',
    city: 'New Delhi',
    state: 'Delhi',
    pincode: '110001',
    phone: '+91 98101 99201',
    email: 'esewa.cp@docusewa.gov.in',
    rating: 4.95,
    reviewCount: 580,
    totalServicesCompleted: 3820,
    avgResponseMinutes: 9,
    reliabilityScore: 99.8,
    cancellationRate: 0.2,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'aadhaar-update': 50,
      'driving-licence': 75,
      'passport': 100,
      'default': 50,
    },
    badges: ['Model CSC Center', 'Premier Partner', 'High Speed Response'],
    workingHours: '8:00 AM - 8:30 PM (Mon-Sat)',
  ),

  const ServiceDealer(
    id: 'jsk_delhi_karolbagh',
    name: 'Jan Suvidha Kendra — Karol Bagh',
    operatorName: 'Manpreet Singh (Certified Operator)',
    authCertNumber: 'JSK-DL-33910',
    centerType: 'Jan Seva Kendra',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 28.6510,
    longitude: 77.1900,
    address: 'Gali No. 4, Gurudwara Road, Karol Bagh',
    locality: 'Karol Bagh',
    city: 'New Delhi',
    state: 'Delhi',
    pincode: '110005',
    phone: '+91 98114 77810',
    email: 'suvidha.kb@docusewa.gov.in',
    rating: 4.82,
    reviewCount: 240,
    totalServicesCompleted: 1250,
    avgResponseMinutes: 18,
    reliabilityScore: 97.4,
    cancellationRate: 0.8,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'driving-licence': 60,
      'default': 50,
    },
    badges: ['Govt Certified', 'Prompt Delivery'],
    workingHours: '9:30 AM - 7:00 PM (Mon-Sat)',
  ),

  // --- LUCKNOW (Hazratganj / Gomti Nagar) ---
  const ServiceDealer(
    id: 'csc_lucknow_hazratganj',
    name: 'Avadh Jan Seva Kendra — Hazratganj',
    operatorName: 'Alok Trivedi (Authorized VLE)',
    authCertNumber: 'CSC-UP-LKO-77102',
    centerType: 'Jan Seva Kendra',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 26.8510,
    longitude: 80.9515,
    address: 'Civil Lines, Near GPO, Hazratganj',
    locality: 'Hazratganj',
    city: 'Lucknow',
    state: 'Uttar Pradesh',
    pincode: '226001',
    phone: '+91 94150 88219',
    email: 'lko.hazratganj@docusewa.gov.in',
    rating: 4.91,
    reviewCount: 410,
    totalServicesCompleted: 2780,
    avgResponseMinutes: 10,
    reliabilityScore: 99.1,
    cancellationRate: 0.4,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'driving-licence': 60,
      'ration-card': 40,
      'income-certificate': 40,
      'default': 50,
    },
    badges: ['Top Rated in Lucknow', 'Govt Certified', 'Direct e-District Sync'],
    workingHours: '8:30 AM - 7:30 PM (Mon-Sat)',
  ),

  // --- JAIPUR (Malviya Nagar / MI Road) ---
  const ServiceDealer(
    id: 'emitra_jaipur_malviya',
    name: 'e-Mitra Plus Citizen Center — Malviya Nagar',
    operatorName: 'Sanjay Rathore (e-Mitra Master)',
    authCertNumber: 'RJ-EMITRA-55102',
    centerType: 'e-Mitra Center',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 26.8550,
    longitude: 75.8260,
    address: 'Sector 3 Commercial Complex, Malviya Nagar',
    locality: 'Malviya Nagar',
    city: 'Jaipur',
    state: 'Rajasthan',
    pincode: '302017',
    phone: '+91 94140 33910',
    email: 'emitra.malviya@docusewa.gov.in',
    rating: 4.89,
    reviewCount: 360,
    totalServicesCompleted: 2150,
    avgResponseMinutes: 12,
    reliabilityScore: 98.9,
    cancellationRate: 0.5,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'driving-licence': 60,
      'default': 50,
    },
    badges: ['Govt Certified', 'e-Mitra Gold Center', 'Fast Filing'],
    workingHours: '9:00 AM - 8:00 PM (Mon-Sat)',
  ),

  // --- BENGALURU (HSR Layout / Koramangala) ---
  const ServiceDealer(
    id: 'bangalore_one_hsr',
    name: 'Karnataka One & CSC Center — HSR Layout',
    operatorName: 'Girish Murthy (Authorized Lead)',
    authCertNumber: 'KA-B1-77218',
    centerType: 'CSC Common Service Center',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 12.9135,
    longitude: 77.6460,
    address: '27th Main Rd, Sector 1, HSR Layout',
    locality: 'HSR Layout',
    city: 'Bengaluru',
    state: 'Karnataka',
    pincode: '560102',
    phone: '+91 98450 11928',
    email: 'kone.hsr@docusewa.gov.in',
    rating: 4.94,
    reviewCount: 520,
    totalServicesCompleted: 3410,
    avgResponseMinutes: 8,
    reliabilityScore: 99.6,
    cancellationRate: 0.2,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'driving-licence': 75,
      'default': 50,
    },
    badges: ['Premier Karnataka One', 'Govt Certified', '5-Star Speed'],
    workingHours: '8:00 AM - 8:00 PM (All 7 Days)',
  ),

  // --- MUMBAI (Andheri East) ---
  const ServiceDealer(
    id: 'csc_mumbai_andheri',
    name: 'MahaOnline & CSC Citizen Seva — Andheri East',
    operatorName: 'Deepak Kulkarni (VLE Lead)',
    authCertNumber: 'MH-CSC-MUM-99201',
    centerType: 'CSC Common Service Center',
    isVerified: true,
    isCurrentlyActive: true,
    latitude: 19.1150,
    longitude: 72.8710,
    address: 'Old Nagardas Road, Near Metro Station, Andheri East',
    locality: 'Andheri East',
    city: 'Mumbai',
    state: 'Maharashtra',
    pincode: '400069',
    phone: '+91 98200 44912',
    email: 'mahaonline.andheri@docusewa.gov.in',
    rating: 4.90,
    reviewCount: 460,
    totalServicesCompleted: 2950,
    avgResponseMinutes: 11,
    reliabilityScore: 99.2,
    cancellationRate: 0.4,
    documentSafetyCompliant: true,
    supportedServiceIds: ['*'],
    servicePricing: {
      'pan-card': 50,
      'driving-licence': 70,
      'default': 50,
    },
    badges: ['Govt Certified', 'MahaOnline Authorized', 'Quick Token'],
    workingHours: '8:30 AM - 7:30 PM (Mon-Sat)',
  ),
];

/// Smart Recommendation Service Engine
class DealerRecommendationService {
  DealerRecommendationService._();
  static final DealerRecommendationService instance = DealerRecommendationService._();

  /// Computes ranked dealer recommendations for a selected service and location.
  /// Strictly filters out unverified providers and non-matching capabilities.
  List<DealerRecommendation> getRecommendationsForService({
    required ServiceData service,
    required UserLocation location,
    String sortBy = 'smart', // 'smart', 'distance', 'rating', 'price', 'speed'
  }) {
    final List<DealerRecommendation> recommendations = [];

    // Filter only verified dealers who support this service
    final eligibleDealers = kVerifiedDealersDatabase.where((d) {
      if (!d.isVerified) return false;
      return d.supportsService(service.id, category: service.category);
    }).toList();

    for (final dealer in eligibleDealers) {
      final distanceKm = UserLocationService.calculateDistanceKm(
        location.latitude,
        location.longitude,
        dealer.latitude,
        dealer.longitude,
      );

      final breakdown = _calculateScoreBreakdown(dealer, service, distanceKm);
      final smartScore = _computeCompositeScore(breakdown);
      final highlights = _generateHighlights(dealer, service, distanceKm);
      final reason = _generatePrimaryReason(dealer, service, distanceKm, smartScore);

      recommendations.add(
        DealerRecommendation(
          dealer: dealer,
          distanceKm: distanceKm,
          smartScore: smartScore,
          scoreBreakdown: breakdown,
          matchHighlights: highlights,
          primaryReason: reason,
        ),
      );
    }

    // Apply Sorting
    switch (sortBy) {
      case 'distance':
        recommendations.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case 'rating':
        recommendations.sort((a, b) => b.dealer.rating.compareTo(a.dealer.rating));
        break;
      case 'price':
        recommendations.sort((a, b) {
          final feeA = a.dealer.getFeeForService(service.id);
          final feeB = b.dealer.getFeeForService(service.id);
          return feeA.compareTo(feeB);
        });
        break;
      case 'speed':
        recommendations.sort((a, b) => a.dealer.avgResponseMinutes.compareTo(b.dealer.avgResponseMinutes));
        break;
      case 'smart':
      default:
        // Smart Match: Highest composite recommendation score first
        recommendations.sort((a, b) => b.smartScore.compareTo(a.smartScore));
        break;
    }

    return recommendations;
  }

  /// Calculates individual sub-scores (0 - 100) for all 7 factors
  Map<String, double> _calculateScoreBreakdown(
    ServiceDealer dealer,
    ServiceData service,
    double distanceKm,
  ) {
    // 1. Distance score (Proximity decay: close is high, drops off smoothly)
    // 0 km = 100, 1 km = ~86, 3 km = ~63, 6 km = ~40, 15 km = ~10
    final double distScore = 100.0 * math.exp(-0.15 * distanceKm);

    // 2. Reliability Score (High audit score + ultra-low cancellation)
    final double relScore = math.min(
      100.0,
      dealer.reliabilityScore * (1.0 - (dealer.cancellationRate / 100.0)),
    );

    // 3. Rating & Customer Satisfaction (Bayesian weighted 5-star rating + review depth)
    final double reviewBonus = math.min(10.0, dealer.reviewCount / 50.0);
    final double ratingScore = math.min(
      100.0,
      ((dealer.rating / 5.0) * 90.0) + reviewBonus,
    );

    // 4. Track record & Service Experience (Completed volume)
    final double expScore = math.min(
      100.0,
      40.0 + (math.min(dealer.totalServicesCompleted, 3000) / 3000.0) * 60.0,
    );

    // 5. Availability & Response Time
    double speedScore = 100.0 - (dealer.avgResponseMinutes * 2.5);
    speedScore = math.max(20.0, math.min(100.0, speedScore));
    if (!dealer.isCurrentlyActive) {
      speedScore *= 0.6; // Penalty if currently closed
    }

    // 6. Pricing & Value (Nominal Gov CSC fee ₹50 = 100, higher fees slight penalty)
    final int fee = dealer.getFeeForService(service.id);
    double priceScore = 100.0;
    if (fee > 50) {
      priceScore = math.max(50.0, 100.0 - ((fee - 50) * 1.5));
    }

    return {
      'distance': distScore,
      'reliability': relScore,
      'rating': ratingScore,
      'experience': expScore,
      'speed': speedScore,
      'price': priceScore,
    };
  }

  /// Weighted composite Smart Recommendation Score (0.0 to 100.0)
  double _computeCompositeScore(Map<String, double> breakdown) {
    const double wDist = 0.25;
    const double wRel = 0.20;
    const double wRat = 0.18;
    const double wExp = 0.15;
    const double wSpeed = 0.12;
    const double wPrice = 0.10;

    final double composite = (breakdown['distance']! * wDist) +
        (breakdown['reliability']! * wRel) +
        (breakdown['rating']! * wRat) +
        (breakdown['experience']! * wExp) +
        (breakdown['speed']! * wSpeed) +
        (breakdown['price']! * wPrice);

    return double.parse(composite.toStringAsFixed(1));
  }

  /// Transparent human-readable bullet highlights
  List<String> _generateHighlights(
    ServiceDealer dealer,
    ServiceData service,
    double distanceKm,
  ) {
    final distFormatted = distanceKm < 1.0
        ? '${(distanceKm * 1000).toInt()} m away'
        : '${distanceKm.toStringAsFixed(1)} km away';

    final fee = dealer.getFeeForService(service.id);

    return [
      distFormatted,
      'Verified ${dealer.centerType.contains("CSC") ? "CSC" : "Govt"} Partner',
      '${dealer.rating.toStringAsFixed(1)}★ (${dealer.reviewCount}+ reviews)',
      '⚡ ~${dealer.avgResponseMinutes}m avg response',
      'Completed ${dealer.totalServicesCompleted}+ requests',
      '₹$fee standard fee',
      if (dealer.documentSafetyCompliant) '🛡️ 100% Doc Privacy Audit',
    ];
  }

  /// Primary reason why this dealer is recommended for this citizen
  String _generatePrimaryReason(
    ServiceDealer dealer,
    ServiceData service,
    double distanceKm,
    double smartScore,
  ) {
    final distFormatted = distanceKm < 1.0
        ? '${(distanceKm * 1000).toInt()}m'
        : '${distanceKm.toStringAsFixed(1)} km';

    if (distanceKm <= 1.5 && dealer.rating >= 4.9) {
      return 'Top-rated verified CSC nearest to you ($distFormatted) with ${dealer.reliabilityScore}% reliability score and fast ${dealer.avgResponseMinutes}m turnaround.';
    } else if (dealer.rating >= 4.9) {
      return 'Highest citizen satisfaction (${dealer.rating}★) and proven track record with ${dealer.totalServicesCompleted}+ completed applications.';
    } else if (distanceKm < 3.0) {
      return 'Closest authorized Jan Seva Kendra ($distFormatted) with live active status and zero document retention guarantee.';
    } else {
      return 'Govt certified center with ${dealer.reliabilityScore}% compliance rating and transparent ₹${dealer.getFeeForService(service.id)} fee.';
    }
  }
}
