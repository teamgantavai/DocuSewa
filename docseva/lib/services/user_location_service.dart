import 'dart:math' as math;
import 'package:flutter/foundation.dart';

/// User Location representation for citizen service center matching
class UserLocation {
  final String locality;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final bool isGPS;

  const UserLocation({
    required this.locality,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.isGPS = true,
  });

  String get shortLabel => '$locality, $city';
  String get fullLabel => '$locality, $city, $state ($pincode)';

  UserLocation copyWith({
    String? locality,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? isGPS,
  }) {
    return UserLocation(
      locality: locality ?? this.locality,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isGPS: isGPS ?? this.isGPS,
    );
  }
}

/// Pre-configured citizen locality presets across major administrative regions
final List<UserLocation> kPresetLocations = [
  const UserLocation(
    locality: 'Sector 62 (Electronic City)',
    city: 'Noida',
    state: 'Uttar Pradesh',
    pincode: '201301',
    latitude: 28.6280,
    longitude: 77.3649,
    isGPS: true,
  ),
  const UserLocation(
    locality: 'Connaught Place',
    city: 'New Delhi',
    state: 'Delhi',
    pincode: '110001',
    latitude: 28.6315,
    longitude: 77.2167,
    isGPS: false,
  ),
  const UserLocation(
    locality: 'Indirapuram',
    city: 'Ghaziabad',
    state: 'Uttar Pradesh',
    pincode: '201014',
    latitude: 28.6415,
    longitude: 77.3712,
    isGPS: false,
  ),
  const UserLocation(
    locality: 'Hazratganj',
    city: 'Lucknow',
    state: 'Uttar Pradesh',
    pincode: '226001',
    latitude: 26.8500,
    longitude: 80.9500,
    isGPS: false,
  ),
  const UserLocation(
    locality: 'Malviya Nagar',
    city: 'Jaipur',
    state: 'Rajasthan',
    pincode: '302017',
    latitude: 26.8540,
    longitude: 75.8242,
    isGPS: false,
  ),
  const UserLocation(
    locality: 'HSR Layout',
    city: 'Bengaluru',
    state: 'Karnataka',
    pincode: '560102',
    latitude: 12.9121,
    longitude: 77.6446,
    isGPS: false,
  ),
  const UserLocation(
    locality: 'Andheri East',
    city: 'Mumbai',
    state: 'Maharashtra',
    pincode: '400069',
    latitude: 19.1136,
    longitude: 72.8697,
    isGPS: false,
  ),
  const UserLocation(
    locality: 'Sector 17',
    city: 'Chandigarh',
    state: 'Chandigarh',
    pincode: '160017',
    latitude: 30.7410,
    longitude: 76.7850,
    isGPS: false,
  ),
];

/// Global location state controller
class UserLocationService {
  UserLocationService._();
  static final UserLocationService instance = UserLocationService._();

  static final ValueNotifier<UserLocation> currentLocation =
      ValueNotifier<UserLocation>(kPresetLocations.first);

  /// Change citizen's active location
  static void setLocation(UserLocation newLocation) {
    currentLocation.value = newLocation;
  }

  /// Change location by PIN code or locality match
  static bool setByPincodeOrName(String query) {
    final clean = query.trim().toLowerCase();
    final match = kPresetLocations.firstWhere(
      (loc) =>
          loc.pincode == clean ||
          loc.locality.toLowerCase().contains(clean) ||
          loc.city.toLowerCase().contains(clean),
      orElse: () => currentLocation.value,
    );
    if (match != currentLocation.value) {
      currentLocation.value = match;
      return true;
    }
    return false;
  }

  /// Calculate Haversine distance in kilometers between two geo-coordinates
  static double calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }
}
