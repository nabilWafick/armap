import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_arcore_plugin/flutter_arcore_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/modules/map/models/route_data/route_data.model.dart';
import 'package:test/modules/map/models/route_step/route_step.model.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/utils/utils.dart';
import 'package:vector_math/vector_math_64.dart';

class ARNavigationPage extends ConsumerStatefulWidget {
  final RouteData routeData;
  const ARNavigationPage({
    super.key,
    required this.routeData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ARNavigationPageState();
}

class _ARNavigationPageState extends ConsumerState<ARNavigationPage> {
  ArCoreController arCoreController = ArCoreController(id: 1);
  List<ArCoreNode> routeNodes = [];
  final double visibilityThreshold = 100; // meters
  Set<LatLng> placedPoints = {};
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();

    if (statuses[Permission.location]!.isGranted &&
        statuses[Permission.camera]!.isGranted) {
      _startPeriodicUpdate();
    }
  }

  void _startPeriodicUpdate() {
    _updateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        _updateARView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ArCoreView(
      onArCoreViewCreated: _onArCoreViewCreated,
      enableTapRecognizer: true,
      enableUpdateListener: true,
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _updateARView();
  }

  void _updateARView() {
    final currentPosition = ref.watch(currentUserLocationProvider);
    if (currentPosition == null) return;

    for (int i = 0; i < widget.routeData.points.length; i++) {
      LatLng point = widget.routeData.points[i];
      if (!placedPoints.contains(point) &&
          _isWithinVisibilityThreshold(currentPosition.latLng, point)) {
        _placeObjectAtLocation(
          point.latitude,
          point.longitude,
          i == widget.routeData.points.length - 1,
        );
        placedPoints.add(point);
      }
    }

    for (final turnPoint in widget.routeData.steps) {
      if (!placedPoints.contains(turnPoint.location) &&
          _isWithinVisibilityThreshold(
              currentPosition.latLng, turnPoint.location)) {
        _placeTurnObject(turnPoint);
        placedPoints.add(turnPoint.location);
      }
    }
  }

  bool _placeObjectAtLocation(double lat, double lon, bool isDestination) {
    Vector3 position = _calculateARPosition(lat, lon);

    String startPointObjectUrl =
        "https://raw.githubusercontent.com/nabilWafick/armap_obj/main/arrow/source/arrow.glb";

    String endPointObjectUrl =
        "https://raw.githubusercontent.com/nabilWafick/armap_obj/main/map_pin_location_pin.glb";

    final node = LatLng(lat, lon) == widget.routeData.points.first
        ? ArCoreReferenceNode(
            objectUrl: startPointObjectUrl,
            position: position,
            scale: Vector3(0.2, 0.2, 0.2),
          )
        : !isDestination
            ? ArCoreNode(
                shape: ArCoreCylinder(
                  radius: .5,
                  height: .1,
                  materials: [
                    ArCoreMaterial(
                      color: ARMColors.primary,
                    ),
                  ],
                ),
                position: position,
              )
            : ArCoreReferenceNode(
                objectUrl: endPointObjectUrl,
                position: position,
                scale: Vector3(0.2, 0.2, 0.2),
              );
    arCoreController.addArCoreNodeWithAnchor(node).catchError(
      (e) {
        debugPrint("Error loading AR object: $e");
      },
    );
    routeNodes.add(node);
    return true;
  }

  bool _placeTurnObject(RouteStep turnPoint) {
    Vector3 position = _calculateARPosition(
        turnPoint.location.latitude, turnPoint.location.longitude);

    String objectUrl =
        '"https://raw.githubusercontent.com/nabilWafick/armap_obj/main/arrow/source/arrow.glb"';

    ArCoreReferenceNode node = ArCoreReferenceNode(
      objectUrl: objectUrl,
      position: position,
      scale: Vector3(0.3, 0.3, 0.3),
    );
    arCoreController.addArCoreNode(node).catchError((e) {
      debugPrint("Error loading AR turn object: $e");
    });
    routeNodes.add(node);
    return true;
  }

  Vector3 _calculateARPosition(double lat, double lon) {
    final currentPosition = ref.watch(currentUserLocationProvider);
    double distanceInMeters = Geolocator.distanceBetween(
        currentPosition!.latLng.latitude,
        currentPosition.latLng.longitude,
        lat,
        lon);

    double bearingInRadians = Geolocator.bearingBetween(
            currentPosition.latLng.latitude,
            currentPosition.latLng.longitude,
            lat,
            lon) *
        (pi / 180);

    double x = distanceInMeters * sin(bearingInRadians);
    double z = -distanceInMeters * cos(bearingInRadians);

    return Vector3(x, 0, z);
  }

  bool _isWithinVisibilityThreshold(LatLng position1, LatLng position2) {
    double distance = Geolocator.distanceBetween(
      position1.latitude,
      position1.longitude,
      position2.latitude,
      position2.longitude,
    );
    return distance <= visibilityThreshold;
  }

  @override
  void dispose() {
    arCoreController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }
}
