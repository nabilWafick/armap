import 'package:latlong2/latlong.dart';

class SearchResult {
  final String name;
  final String displayName;
  final LatLng latLng;

  SearchResult({
    required this.name,
    required this.displayName,
    required this.latLng,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      name: json['name'],
      displayName: json['display_name'],
      latLng: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
    );
  }
}
