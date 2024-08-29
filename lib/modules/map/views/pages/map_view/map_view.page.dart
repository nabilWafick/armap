import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/common/models/location/location.model.dart';
import 'package:test/common/services/location/location.service.dart';
import 'package:test/common/widgets/label_value/label_value.model.dart';
import 'package:test/modules/map/controllers/routing/routing.controller.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/modules/map/views/widgets/map_controls/map_controls.widget.dart';
import 'package:test/modules/map/views/widgets/route_configuration_form/route_configuration_form.widget.dart';
import 'package:test/modules/map/views/widgets/search_card/search_card.widget.dart';
import 'package:test/utils/utils.dart';

class MapView extends StatefulHookConsumerWidget {
  const MapView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  final MapController mapController = MapController();
  final LocationService locationService = LocationService();
  StreamSubscription<Position>? positionStream;
  final double visibilityThreshold = 100; // meters

  @override
  void initState() {
    super.initState();
    // ping user current location
    _pingUserCurrentLocatio();

    // streaming user location
    _initLocationTracking();
  }

  Future<Location?> _getCurrentLocation() async {
    try {
      final position = await locationService.getCurrentLocation();

      final userLocation = Location(
        name: 'Current',
        displayName: 'Your position',
        latLng: LatLng(position.latitude, position.longitude),
      );

      ref.read(currentUserLocationProvider.notifier).state = userLocation;

      return userLocation;
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
    return null;
  }

  void _initLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      final userLocation = Location(
        name: 'Current',
        displayName: 'Your position',
        latLng: LatLng(position.latitude, position.longitude),
      );

      ref.read(currentUserLocationProvider.notifier).state = userLocation;
    });
  }

  Future<void> _pingUserCurrentLocatio() async {
    final userLocation = await _getCurrentLocation();

    if (userLocation != null) {
      ref.read(markersProvider.notifier).state = [
        Marker(
          point: LatLng(
              userLocation.latLng.latitude, userLocation.latLng.longitude),
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
      ];
    }
  }

  Future<void> _moveToCurrentLocation() async {
    final userLocation = await _getCurrentLocation();

    if (userLocation != null) {
      ref.read(markersProvider.notifier).state = [
        Marker(
          point: LatLng(
              userLocation.latLng.latitude, userLocation.latLng.longitude),
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
      ];
      mapController.move(userLocation.latLng, 17);
    }
  }

  void _addMeasurePoint(LatLng point) {
    final measurePoints = ref.watch(measurePointsProvider);
    ref.read(measurePointsProvider.notifier).update(
          (state) => [
            ...state,
            point,
          ],
        );

    if (measurePoints.length > 1) {
      ref.read(measuredDistanceProvider.notifier).update(
            (state) => state += _calculateDistance(
              measurePoints[measurePoints.length - 2],
              measurePoints[measurePoints.length - 1],
            ),
          );
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((end.latitude - start.latitude) * p) / 2 +
        c(start.latitude * p) *
            c(end.latitude * p) *
            (1 - c((end.longitude - start.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  _showRouteConfigBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return RouteConfigurationForm(
          mapController: mapController,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserLocation = ref.watch(currentUserLocationProvider);
    final markers = ref.watch(markersProvider);
    final polylines = ref.watch(polylinesProvider);
    final toggleMeasureMode = ref.watch(toggleMeasureModeProvider);
    final measurePoints = ref.watch(measurePointsProvider);
    final measuredDistance = ref.watch(measuredDistanceProvider);
    final startPoint = ref.watch(startPointProvider);
    final endPoint = ref.watch(endPointProvider);
    final travelMode = ref.watch(travelModeProvider);

    // listen travel mode change
    ref.listen(travelModeProvider, (previous, next) {
      if (startPoint != null && endPoint != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final routeData = await RoutingController.getRoute(
            startPoint: startPoint,
            endPoint: endPoint,
            travelMode: travelMode,
          );

          // display route info
          ref.read(travelRouteProvider.notifier).state = routeData;

          // place markers
          ref.read(markersProvider.notifier).state = [
            Marker(
              point: LatLng(
                startPoint.latLng.latitude,
                startPoint.latLng.longitude,
              ),
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
            if (currentUserLocation?.latLng == startPoint.latLng)
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
              point: LatLng(
                endPoint.latLng.latitude,
                endPoint.latLng.longitude,
              ),
              width: 50,
              height: 50,
              child: Icon(
                Icons.location_pin,
                color: Colors.red[700],
              ),
            ),
          ];

          // draw route
          ref.read(polylinesProvider.notifier).state = [
            Polyline(
              points: routeData.points,
              color: ARMColors.primary,
              strokeWidth: 7.0,
            ),
          ];

          mapController.move(startPoint.latLng, 12);
        });
      }
    });

    // listen start point update
    ref.listen(startPointProvider, (previous, next) {
      if (next != null && endPoint != null) {
        // Todo
        // fetch polylines
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final routeData = await RoutingController.getRoute(
            startPoint: next,
            endPoint: endPoint,
            travelMode: travelMode,
          );

          // debugPrint('Travel Duration: ${routeData.totalDuration}');

          // display route info
          ref.read(travelRouteProvider.notifier).state = routeData;

          // place markers
          ref.read(markersProvider.notifier).state = [
            Marker(
              point: LatLng(
                next.latLng.latitude,
                next.latLng.longitude,
              ),
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
            if (currentUserLocation?.latLng == next.latLng)
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
              point: LatLng(
                endPoint.latLng.latitude,
                endPoint.latLng.longitude,
              ),
              width: 50,
              height: 50,
              child: Icon(
                Icons.location_pin,
                color: Colors.red[700],
              ),
            ),
          ];

          // draw route
          ref.read(polylinesProvider.notifier).state = [
            Polyline(
              points: routeData.points,
              color: ARMColors.primary,
              strokeWidth: 7.0,
            ),
          ];

          mapController.move(next.latLng, 12);
        });
      }
    });

    // listen end point update
    ref.listen(endPointProvider, (previous, next) {
      if (next != null && startPoint != null) {
        // Todo
        // fetch polylines
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final routeData = await RoutingController.getRoute(
            startPoint: startPoint,
            endPoint: next,
            travelMode: travelMode,
          );

          // debugPrint('Travel Duration: ${routeData.totalDuration}');

          // display route info
          ref.read(travelRouteProvider.notifier).state = routeData;

          // place markers
          ref.read(markersProvider.notifier).state = [
            Marker(
              point: LatLng(
                startPoint.latLng.latitude,
                startPoint.latLng.longitude,
              ),
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
            if (currentUserLocation?.latLng == startPoint.latLng)
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
              point: LatLng(
                next.latLng.latitude,
                next.latLng.longitude,
              ),
              width: 50,
              height: 50,
              child: Icon(
                Icons.location_pin,
                color: Colors.red[700],
              ),
            ),
          ];

          // draw route
          ref.read(polylinesProvider.notifier).state = [
            Polyline(
              points: routeData.points,
              color: ARMColors.primary,
              strokeWidth: 7.0,
            ),
          ];

          mapController.move(startPoint.latLng, 12);
        });
      }
    });

    return SafeArea(
      child: currentUserLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentUserLocation.latLng,
                initialZoom: 17.0,
                onTap: (tapPosition, point) {
                  if (toggleMeasureMode) {
                    setState(() {
                      _addMeasurePoint(point);
                    });
                  }
                },
                minZoom: ARMConstants.minZoom,
                maxZoom: ARMConstants.maxZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mfl.armap',
                ),
                MarkerLayer(
                  markers: markers,
                ),
                PolylineLayer(
                  polylines: [
                    ...polylines,
                    if (toggleMeasureMode)
                      Polyline(
                        points: measurePoints,
                        color: Colors.green.shade500,
                        strokeWidth: 5.0,
                      )
                  ],
                ),
                !toggleMeasureMode
                    ? SearchCard(
                        mapController: mapController,
                        text: 'Place ...',
                        hintText: 'Search for a place',
                        isSimpleSearch: true,
                        prefixIcon: HugeIcons.strokeRoundedLocation01,
                        suffixIcon: HugeIcons.strokeRoundedSearch01,
                        suffixIconColor: ARMColors.primary,
                        locationProvider: searchedLocationProvider,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 10.0,
                            ),
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LabelValue(
                                  label: 'Distance',
                                  value:
                                      '${measuredDistance.toStringAsFixed(3)}km',
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                MapControls(
                  onCenterToUser: _moveToCurrentLocation,
                  showRouteConfigBottomSheet: _showRouteConfigBottomSheet,
                ),
              ],
            ),
    );
  }
}
