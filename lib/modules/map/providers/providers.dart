import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/common/models/search_result/search_result.model.dart';

final currentUserLocationProvider = StateProvider<LatLng?>((ref) {
  return;
});

final isSearchingProvider = StateProvider<bool>((ref) {
  return false;
});

final searchedLocationProvider = StateProvider<SearchResult?>((ref) {
  return;
});

final searchResultsProvider = StateProvider<List<SearchResult>>((ref) {
  return [];
});

final markersProvider = StateProvider<List<Marker>>((ref) {
  return [];
});

final startPointProvider = StateProvider<SearchResult?>((ref) {
  return;
});

final endPointProvider = StateProvider<SearchResult?>((ref) {
  return;
});

final polylinesProvider = StateProvider<List<Polyline>>((ref) {
  return [];
});

final selectedTransportTypeProvider = StateProvider<int>((ref) {
  return 0;
});

final toggleMeasureModeProvider = StateProvider<bool>((ref) {
  return false;
});

final measurePointsProvider = StateProvider<List<LatLng>>((ref) {
  return [];
});

final measuredDistanceProvider = StateProvider<num>((ref) {
  return 0;
});
