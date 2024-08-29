import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/icon_button/icon_button.widget.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/modules/ar/navigation/navigation.page.dart';
import 'package:test/modules/map/models/travel_mode/travel_mode.model.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/modules/map/views/pages/steps/steps_list.page.dart';
import 'package:test/modules/map/views/widgets/search_card/search_card.widget.dart';
import 'package:test/modules/map/views/widgets/transport_type/transport_type.widget.dart';
import 'package:test/utils/colors/colors.util.dart';

class RouteConfigurationForm extends StatefulHookConsumerWidget {
  final MapController mapController;
  const RouteConfigurationForm({
    super.key,
    required this.mapController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RouteConfigurationFormState();
}

class _RouteConfigurationFormState
    extends ConsumerState<RouteConfigurationForm> {
  @override
  Widget build(BuildContext context) {
    final travelRoute = ref.watch(travelRouteProvider);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 10.0,
      ),
      /*  decoration: BoxDecoration(
        color: Colors.blueGrey[300],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            35.0,
          ),
          topRight: Radius.circular(
            35.0,
          ),
        ),
      ),
     */
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ARMText(
            text: 'Route',
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 20.0,
              bottom: 25.0,
            ),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  TransportType(
                    type: TravelMode.driving,
                    icon: Icons.directions_car_outlined,
                    name: 'Driving',
                  ),
                  TransportType(
                    type: TravelMode.cycling,
                    icon: Icons.motorcycle_outlined,
                    name: 'Cycling',
                  ),
                  TransportType(
                    type: TravelMode.foot,
                    icon: Icons.directions_walk_outlined,
                    name: 'Foot',
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Column(
                children: [
                  SearchCard(
                    mapController: widget.mapController,
                    text: 'Start Point',
                    hintText: 'Choose a start point',
                    isSimpleSearch: false,
                    prefixIcon: Icons.account_circle_rounded,
                    suffixIcon: Icons.edit_rounded,
                    suffixIconColor: Colors.grey.shade400,
                    locationProvider: startPointProvider,
                  ),
                  SearchCard(
                    mapController: widget.mapController,
                    text: 'End Point',
                    hintText: 'Choose an end point',
                    isSimpleSearch: false,
                    prefixIcon: Icons.flag_rounded,
                    suffixIcon: Icons.edit_rounded,
                    suffixIconColor: Colors.grey.shade400,
                    locationProvider: endPointProvider,
                  ),
                  const SizedBox(
                    height: 25.0,
                  )
                ],
              ),
              Positioned(
                left: 250.0,
                top: 45.0,
                child: InkWell(
                  onTap: () {
                    final startPoint = ref.watch(startPointProvider);
                    final endPoint = ref.watch(endPointProvider);

                    if (startPoint != null && endPoint != null) {
                      final interm = ref.read(startPointProvider);

                      ref.read(startPointProvider.notifier).state = endPoint;

                      ref.read(endPointProvider.notifier).state = interm;
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: const BoxDecoration(
                      color: ARMColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          spreadRadius: .5,
                          color: ARMColors.primary,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          travelRoute != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ARMIconButton(
                      icon: Icons.keyboard_double_arrow_up_rounded,
                      text: 'Overview',
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ARMIconButton(
                      icon: Icons.list_rounded,
                      text: 'Steps',
                      onTap: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return const StepsListPage();
                          },
                        );
                      },
                    ),
                    ARMIconButton(
                      icon: Icons.keyboard_double_arrow_up_rounded,
                      text: 'AR View',
                      onTap: () {
                        final routeData = ref.read(travelRouteProvider);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ARNavigationPage(
                              routeData: routeData!,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
