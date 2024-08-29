import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/widgets.common.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/utils/utils.dart';

class StepsOverview extends StatefulHookConsumerWidget {
  const StepsOverview({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StepsOverviewState();
}

class _StepsOverviewState extends ConsumerState<StepsOverview> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // define the step passed as the selectedbb
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedStep = ref.watch(selectedRouteStepProvider);
    final controller = MapController.of(context);
    final currentUserLocation = ref.watch(currentUserLocationProvider);
    final markers = ref.watch(markersProvider);
    final polylines = ref.watch(polylinesProvider);
    final routeData = ref.watch(travelRouteProvider);
    final stepCounter = useState<int>(routeData!.steps.indexOf(selectedStep!));

    return Scaffold(
      appBar: AppBar(
        title: const ARMText(text: 'Steps Overview'),
        bottom: PreferredSize(
          preferredSize: const Size(
            double.infinity,
            30,
          ),
          child: Container(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Row(
              children: [
                Icon(
                  selectedStep.icon,
                  color: ARMColors.primary,
                  size: 30.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    ARMText(
                      text: selectedStep.distance,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ARMText(
                      text: selectedStep.instruction,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: currentUserLocation!.latLng,
          initialZoom: 17.0,
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
            polylines: polylines,
          ),
          Positioned(
            bottom: 50.0,
            right: 16.0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'Center To User',
                  onPressed: () {},
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (stepCounter.value != 0) {
                          ref.read(selectedRouteStepProvider.notifier).state =
                              routeData.steps[stepCounter.value - 1];

                          controller.move(
                              routeData.points[stepCounter.value - 1], 15);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: stepCounter.value != 0
                                ? ARMColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: stepCounter.value != 0
                              ? Colors.white
                              : ARMColors.primary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (stepCounter.value != routeData.steps.length - 1) {
                          ref.read(selectedRouteStepProvider.notifier).state =
                              routeData.steps[stepCounter.value + 1];

                          controller.move(
                              routeData.points[stepCounter.value + 1], 15);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color:
                                stepCounter.value != routeData.steps.length - 1
                                    ? ARMColors.primary
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: stepCounter.value != routeData.steps.length - 1
                              ? Colors.white
                              : ARMColors.primary,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
