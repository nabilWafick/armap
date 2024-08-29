import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/common/models/location/location.model.dart';
import 'package:test/modules/map/models/map.models.dart';
import 'package:test/modules/map/models/route_data/route_data.model.dart';
import 'package:test/modules/map/models/route_step/route_step.model.dart';

final currentUserLocationProvider = StateProvider<Location?>((ref) {
  return;
});

final isSearchingProvider = StateProvider<bool>((ref) {
  return false;
});

final searchedLocationProvider = StateProvider<Location?>((ref) {
  return;
});

final searchedLocationsProvider = StateProvider<List<Location>>((ref) {
  return [];
});

final markersProvider = StateProvider<List<Marker>>((ref) {
  return [];
});

final startPointProvider = StateProvider<Location?>((ref) {
  return;
});

final endPointProvider = StateProvider<Location?>((ref) {
  return;
});

final travelModeProvider = StateProvider<String>((ref) {
  return TravelMode.driving;
});

final travelRouteProvider = StateProvider<RouteData?>((ref) {
  return;
});

final polylinesProvider = StateProvider<List<Polyline>>((ref) {
  return <Polyline>[];
});

final selectedRouteStepProvider = StateProvider<RouteStep?>((ref) {
  return;
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
