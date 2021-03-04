import 'package:geolocator/geolocator.dart';

class LocationProvider {
  double checkLocationDistance(
    double startLon,
    double startLat,
    double endLon,
    double endLat,
  ) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLat,
      startLon,
      endLat,
      endLon,
    );
    return distanceInMeters;
  }
}
