import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/modules/map/providers/providers.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  TransportType(
                    index: 0,
                    icon: Icons.directions_car_outlined,
                    name: 'Driving',
                    duration: '15 min',
                    onTap: () {},
                  ),
                  TransportType(
                    index: 1,
                    icon: Icons.motorcycle_outlined,
                    name: 'Cycling',
                    duration: '18 min',
                    onTap: () {},
                  ),
                  TransportType(
                    index: 2,
                    icon: Icons.directions_walk_outlined,
                    name: 'Foot',
                    duration: '40 min',
                    onTap: () {},
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
                    hintText: 'Start Point',
                    prefixIcon: Icons.account_circle_rounded,
                    suffixIcon: Icons.edit_rounded,
                    suffixIconColor: Colors.grey.shade400,
                    locationProvider: startPointProvider,
                  ),
                  SearchCard(
                    mapController: widget.mapController,
                    hintText: 'End Point',
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
                  onTap: () {},
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
        ],
      ),
    );
  }
}
