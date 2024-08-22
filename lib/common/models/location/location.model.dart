import 'package:latlong2/latlong.dart';

class Location {
  final String name;
  final String displayName;
  final LatLng latLng;

  Location({
    required this.name,
    required this.displayName,
    required this.latLng,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      displayName: json['display_name'],
      latLng: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
    );
  }
}
