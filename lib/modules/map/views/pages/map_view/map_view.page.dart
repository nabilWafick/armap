import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/common/services/location/location.service.dart';
import 'package:test/common/services/search/search.service.dart';
import 'package:test/common/widgets/label_value/label_value.model.dart';
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
  final SearchService searchService = SearchService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await locationService.getCurrentLocation();
      ref.read(currentUserLocationProvider.notifier).state =
          LatLng(position.latitude, position.longitude);

      ref.read(markersProvider.notifier).state = [
        Marker(
          point: LatLng(position.latitude, position.longitude),
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

      mapController.move(ref.watch(currentUserLocationProvider)!, 17);
    } catch (e) {
      debugPrint('Error getting location: $e');
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

    return SafeArea(
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter:
                  currentUserLocation ?? const LatLng(51.509364, -0.128928),
              initialZoom: 15.0,
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
                  ? /*InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchPage(
                              mapController: mapController,
                              isSimpleSearch: true,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedLocation01,
                                  color: ARMColors.primary,
                                  size: 20.0,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  searchedLocation != null
                                      ? searchedLocation.name
                                      : 'Search for a place',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedSearch01,
                              color: Colors.blue,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                    )
                 */
                  SearchCard(
                      mapController: mapController,
                      hintText: 'Search for a place',
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
                onCenterToUser: _getCurrentLocation,
                showRouteConfigBottomSheet: _showRouteConfigBottomSheet,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
