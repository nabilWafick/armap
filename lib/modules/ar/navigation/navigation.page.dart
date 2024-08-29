import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_arcore_plugin/flutter_arcore_plugin.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:test/modules/map/models/route_data/route_data.model.dart';
import 'package:test/modules/map/models/route_step/route_step.model.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/utils/utils.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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
  final MapController mapController = MapController();
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
    final currentUserLocation = ref.watch(currentUserLocationProvider);
    return Stack(
      children: [
        ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
          enableUpdateListener: true,
        ),
        DraggableScrollableSheet(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: ShapeOfView(
                shape: ArcShape(
                  position: ArcPosition.Top,
                  height: 40.0,
                ),
                height: MediaQuery.of(context).size.height,
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: widget.routeData.points.first,
                    initialZoom: 15.0,
                    minZoom: ARMConstants.minZoom,
                    maxZoom: ARMConstants.maxZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.mfl.armap',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(currentUserLocation!.latLng.latitude,
                              currentUserLocation.latLng.longitude),
                          width: 17,
                          height: 17,
                          child: const Card(
                            elevation: 2.0,
                            color: ARMColors.primary,
                            shape: CircleBorder(
                              side: BorderSide(
                                width: 2.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Marker(
                          point: widget.routeData.points.first,
                          width: 14,
                          height: 14,
                          child: Card(
                            elevation: 1.0,
                            color: Colors.grey.shade400,
                            shape: const CircleBorder(
                              side: BorderSide(
                                width: 1.0,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                        Marker(
                          point: widget.routeData.points.last,
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: widget.routeData.points,
                          color: ARMColors.primary,
                          strokeWidth: 5.0,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
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
    vector.Vector3 position = _calculateARPosition(lat, lon);

    String startPointObjectUrl =
        "https://raw.githubusercontent.com/nabilWafick/armap_obj/main/arrow/source/arrow.glb";

    String endPointObjectUrl =
        "https://raw.githubusercontent.com/nabilWafick/armap_obj/main/map_pin_location_pin.glb";

    final node = LatLng(lat, lon) == widget.routeData.points.first
        ? ArCoreReferenceNode(
            objectUrl: startPointObjectUrl,
            position: position,
            scale: vector.Vector3(0.2, 0.2, 0.2),
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
                scale: vector.Vector3(0.2, 0.2, 0.2),
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
    vector.Vector3 position = _calculateARPosition(
        turnPoint.location.latitude, turnPoint.location.longitude);

    String objectUrl =
        '"https://raw.githubusercontent.com/nabilWafick/armap_obj/main/arrow/source/arrow.glb"';

    ArCoreReferenceNode node = ArCoreReferenceNode(
      objectUrl: objectUrl,
      position: position,
      scale: vector.Vector3(0.3, 0.3, 0.3),
    );
    arCoreController.addArCoreNode(node).catchError((e) {
      debugPrint("Error loading AR turn object: $e");
    });
    routeNodes.add(node);
    return true;
  }

  vector.Vector3 _calculateARPosition(double lat, double lon) {
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

    return vector.Vector3(x, 0, z);
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
