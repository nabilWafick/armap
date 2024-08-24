import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/common/models/location/location.model.dart';
import 'package:test/modules/map/models/route_data/route_data.model.dart';
import 'package:test/modules/map/models/route_step/route_step.model.dart';
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
      final stepsInstructions = steps
          .map<RouteStep>(
            (step) => generateInstruction(
              step: step,
            ),
          )
          .toList();
      final totalDistance = route["distance"] ~/ 1000 > 0
          ? "${(route["distance"] / 1000).toStringAsFixed(2)} km"
          : "${route["distance"].toStringAsFixed(2)} m";
      final totalDuration = formatTime(seconds: route['duration'].toInt());

      return RouteData(
        points: points,
        steps: stepsInstructions,
        totalDistance: totalDistance,
        totalDuration: totalDuration,
      );
    }

    return RouteData(
      points: [],
      steps: [],
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

RouteStep generateInstruction({required Map<String, dynamic> step}) {
  final maneuver = step['maneuver'];
  final type = maneuver['type'];
  final modifier = maneuver['modifier'];
  final name = step['name'];

  final location = LatLng(
    maneuver["location"][1],
    maneuver["location"][0],
  );
  String instruction = '';
  IconData icon = Icons.hourglass_empty_rounded;
  String distance = step["distance"] ~/ 1000 > 0
      ? "${(step["distance"] / 1000).toStringAsFixed(2)} km"
      : "${step["distance"].toStringAsFixed(2)} m";

  switch (type) {
    case 'turn':
      if (modifier == 'left') {
        instruction = 'Turn left onto $name';
        icon = Icons.turn_left_rounded; // Material icon for left turn
      } else if (modifier == 'right') {
        instruction = 'Turn right onto $name';
        icon = Icons.turn_right_rounded; // Material icon for right turn
      } else {
        instruction = 'Turn onto $name';
        icon = Icons.turn_slight_right_rounded; // Material icon for turn
      }
      break;
    case 'new name':
      instruction = 'Continue onto $name';
      icon = Icons.trending_flat_rounded; // Material icon for continue
      break;
    case 'depart':
      instruction = 'Depart';
      icon = Icons.start_rounded; // Material icon for depart
      break;
    case 'arrive':
      instruction = 'Arrive at your destination';
      icon = Icons.location_on_rounded; // Material icon for arrive
      break;
    case 'merge':
      instruction = 'Merge onto $name';
      icon = Icons.merge_rounded; // Material icon for merge
      break;
    case 'on ramp':
      instruction = 'Take the ramp onto $name';
      icon = Icons.traffic; // Material icon for ramp
      break;
    case 'off ramp':
      instruction = 'Take the exit for $name';
      icon = Icons.exit_to_app_rounded; // Material icon for off ramp
      break;
    case 'fork':
      instruction = 'At the fork, take the $modifier route';
      icon = modifier.contains('right')
          ? Icons.fork_right_rounded
          : Icons.fork_left_rounded; // Material icon for fork
      break;
    case 'end of road':
      instruction = 'Reach the end of road $name';
      icon = Icons.stop_rounded; // Material icon for end of road
      break;
    case 'roundabout':
      instruction = 'Enter the roundabout and take the $modifier exit';
      icon = Icons.circle_outlined; // Material icon for roundabout
      break;
    case 'rotary':
      instruction = 'Enter the rotary and take the $modifier exit';
      icon = Icons.circle_outlined; // Material icon for rotary
      break;
    case 'roundabout turn':
      instruction = 'At the roundabout, take the $modifier exit onto $name';
      icon = Icons.circle_outlined; // Material icon for roundabout turn
      break;
    case 'notification':
      instruction = '${capitalize(text: modifier ?? '')} $name';
      icon = Icons.notifications_rounded; // Material icon for notification
      break;
    default:
      instruction =
          '${capitalize(text: type ?? '')} ${modifier ?? ''} ${name ?? ''}'
              .trim();
      icon = type.contains("exit")
          ? Icons.exit_to_app_rounded
          : Icons.question_mark; // Material icon for default case
  }

  return RouteStep(
    location: location,
    instruction: instruction,
    distance: distance,
    icon: icon,
  );
}

String capitalize({required String text}) {
  return "${text[0].toUpperCase()}${text.substring(1)}";
}

String formatTime({required int seconds}) {
  if (seconds < 0) {
    throw ArgumentError('Seconds cannot be negative');
  }

  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;

  int days = minutes ~/ (60 * 24);
  int remainingHours = (minutes % (60 * 24)) ~/ 60;
  int remainingMinutes = minutes % 60;

  String timeString = '';

  if (days > 0) {
    timeString += '$days d ';
  }

  if (remainingHours > 0) {
    timeString += '$remainingHours h ';
  }

  if (remainingMinutes > 0) {
    timeString += '$remainingMinutes min ';
  }

  if (remainingSeconds > 0) {
    timeString += '$remainingSeconds s';
  }

  return timeString.trim();
}
