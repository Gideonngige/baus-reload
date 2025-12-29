import 'dart:math';

// calculate distance between two coordinates using Haversine formula
double calculateDistanceKm(double lat1, double lng1, double lat2, double lng2) {
  const R = 6371; // Radius of Earth in km
  final dLat = _toRadians(lat2 - lat1);
  final dLng = _toRadians(lng2 - lng1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
      sin(dLng / 2) * sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _toRadians(double degree) => degree * pi / 180;

// get delivery zone based on distance in kilometers
int getDeliveryZone(double distanceKm) {
  if (distanceKm <= 10) {
    return 1; // Same town / city
  } else if (distanceKm <= 50) {
    return 2; // Nearby counties
  } else if (distanceKm <= 150) {
    return 3; // Major towns
  } else {
    return 4; // Remote / last-mile
  }
}

