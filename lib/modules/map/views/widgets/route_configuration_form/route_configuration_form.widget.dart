import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/common/widgets/textformfield/textformfield.widget.dart';
import 'package:test/modules/map/views/transport_type/transport_type.widget.dart';
import 'package:test/utils/colors/colors.util.dart';

class RouteConfigurationForm extends StatefulHookConsumerWidget {
  const RouteConfigurationForm({super.key});

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
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            35.0,
          ),
          topRight: Radius.circular(
            35.0,
          ),
        ),
      ),
      child: Column(
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
                    index: 2,
                    icon: Icons.directions_car_outlined,
                    name: 'Driving',
                    duration: '15 min',
                    onTap: () {},
                  ),
                  TransportType(
                    index: 3,
                    icon: Icons.motorcycle_outlined,
                    name: 'Cycling',
                    duration: '18 min',
                    onTap: () {},
                  ),
                  TransportType(
                    index: 4,
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
                  ARMTextFormField(
                    hintText: 'Start Point',
                    label: 'Start',
                    isMultilineTextForm: false,
                    obscureText: false,
                    prefixIcon: Icons.account_circle,
                    suffixIcon: Icons.edit,
                    textInputType: TextInputType.text,
                    validator: (p0, p1) {
                      return;
                    },
                    onChanged: (p0, p1) {},
                  ),
                  ARMTextFormField(
                    hintText: 'End Point',
                    label: 'Arrival',
                    isMultilineTextForm: false,
                    obscureText: false,
                    prefixIcon: Icons.flag,
                    suffixIcon: Icons.edit,
                    textInputType: TextInputType.text,
                    validator: (p0, p1) {
                      return;
                    },
                    onChanged: (p0, p1) {},
                  ),
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
