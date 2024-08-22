import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class RouteData {
  final List<LatLng> points;
  final List<String> instructions;
  final String totalDistance;
  final String totalDuration;
  RouteData({
    required this.points,
    required this.instructions,
    required this.totalDistance,
    required this.totalDuration,
  });

  RouteData copyWith({
    List<LatLng>? points,
    List<String>? instructions,
    String? totalDistance,
    String? totalDuration,
  }) {
    return RouteData(
      points: points ?? this.points,
      instructions: instructions ?? this.instructions,
      totalDistance: totalDistance ?? this.totalDistance,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  @override
  String toString() {
    return 'RouteData(points: $points, instructions: $instructions, totalDistance: $totalDistance, totalDuration: $totalDuration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteData &&
        listEquals(other.points, points) &&
        listEquals(other.instructions, instructions) &&
        other.totalDistance == totalDistance &&
        other.totalDuration == totalDuration;
  }

  @override
  int get hashCode {
    return points.hashCode ^
        instructions.hashCode ^
        totalDistance.hashCode ^
        totalDuration.hashCode;
  }
}
