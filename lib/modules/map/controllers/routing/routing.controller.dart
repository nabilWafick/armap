import 'package:latlong2/latlong.dart';
import 'package:test/common/models/location/location.model.dart';
import 'package:test/modules/map/models/route_data/route_data.model.dart';
import 'package:test/modules/map/services/map.services.dart';

class RoutingController {
  static Future<RouteData> getRoute({
    required Location startPoint,
    required Location endPoint,
    required String travelMode,
  }) async {
    final response = await RoutingService.getRoute(
      startPoint: startPoint,
      endPoint: endPoint,
      travelMode: travelMode,
    );

    if (response.statusCode == 200 && response.data['code'] == 'Ok') {
      final route = response.data['routes'][0];
      final geometry = route['geometry'];
      final legs = route['legs'][0];
      final steps = legs['steps'];

      final points = extractCoordinates(geometry);
      final instructions =
          steps.map<String>((step) => generateInstruction(step)).toList();
      final totalDistance =
          (route['distance'] / 1000).toStringAsFixed(2) + ' km';
      final totalDuration =
          (route['duration'] / 60).toStringAsFixed(0) + ' min';

      return RouteData(
        points: points,
        instructions: instructions,
        totalDistance: totalDistance,
        totalDuration: totalDuration,
      );
    }

    return RouteData(
      points: [],
      instructions: [],
      totalDistance: '- km',
      totalDuration: '- min',
    );
  }
}

List<LatLng> extractCoordinates(Map<String, dynamic> geometry) {
  if (geometry['type'] == 'LineString') {
    return geometry['coordinates']
        .map<LatLng>(
          (coord) => LatLng(coord[1], coord[0]),
        )
        .toList();
  }
  return [];
}

String generateInstruction(Map<String, dynamic> step) {
  final maneuver = step['maneuver'];
  final type = maneuver['type'];
  final modifier = maneuver['modifier'];
  final name = step['name'];

  String instruction = '';

  switch (type) {
    case 'turn':
      instruction = 'Turn ${modifier ?? ''} onto $name';
      break;
    case 'new name':
      instruction = 'Continue ${modifier ?? ''} onto $name';
      break;
    case 'depart':
      instruction = 'Depart';
      break;
    case 'arrive':
      instruction = 'Arrive at your destination';
      break;
    case 'merge':
      instruction = 'Merge ${modifier ?? ''} onto $name';
      break;
    case 'on ramp':
      instruction = 'Take the ramp ${modifier ?? ''} onto $name';
      break;
    default:
      instruction =
          '${capitalize(text: type ?? '')} ${modifier ?? ''} ${name ?? ''}'
              .trim();
  }

  return instruction;
}

String capitalize({required String text}) {
  return "${text.toUpperCase()}${text.substring(1)}";
}
