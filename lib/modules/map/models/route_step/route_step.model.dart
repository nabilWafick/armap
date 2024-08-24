import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RouteStep {
  final String instruction;
  final String distance;
  final LatLng location;
  final IconData icon;
  RouteStep({
    required this.instruction,
    required this.distance,
    required this.location,
    required this.icon,
  });

  RouteStep copyWith({
    String? instruction,
    String? distance,
    LatLng? location,
    IconData? icon,
  }) {
    return RouteStep(
      instruction: instruction ?? this.instruction,
      distance: distance ?? this.distance,
      location: location ?? this.location,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteStep &&
        other.instruction == instruction &&
        other.distance == distance &&
        other.location == location &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return instruction.hashCode ^
        distance.hashCode ^
        location.hashCode ^
        icon.hashCode;
  }
}
