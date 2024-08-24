import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/modules/map/models/route_step/route_step.model.dart';

class RouteData {
  final List<LatLng> points;
  final List<RouteStep> steps;
  final String totalDistance;
  final String totalDuration;
  RouteData({
    required this.points,
    required this.steps,
    required this.totalDistance,
    required this.totalDuration,
  });

  RouteData copyWith({
    List<LatLng>? points,
    List<RouteStep>? steps,
    String? totalDistance,
    String? totalDuration,
  }) {
    return RouteData(
      points: points ?? this.points,
      steps: steps ?? this.steps,
      totalDistance: totalDistance ?? this.totalDistance,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  @override
  String toString() {
    return 'RouteData(points: $points, steps: $steps, totalDistance: $totalDistance, totalDuration: $totalDuration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteData &&
        listEquals(other.points, points) &&
        listEquals(other.steps, steps) &&
        other.totalDistance == totalDistance &&
        other.totalDuration == totalDuration;
  }

  @override
  int get hashCode {
    return points.hashCode ^
        steps.hashCode ^
        totalDistance.hashCode ^
        totalDuration.hashCode;
  }
}
