// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/utils/colors/colors.util.dart';

class RouteInfo extends StatefulHookConsumerWidget {
  final IconData icon;
  final String name;
  final String value;
  final Function() onTap;
  const RouteInfo({
    super.key,
    required this.icon,
    required this.name,
    required this.value,
    required this.onTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RouteInfoState();
}

class _RouteInfoState extends ConsumerState<RouteInfo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: 3.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 7.0,
            bottom: 7.0,
            left: 7.0,
            right: 12.0,
          ),
          /* decoration: BoxDecoration(
            border: Border.all(
              color: ARMColors.primary.withOpacity(.7),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(
              15.0,
            ),
          ),*/
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: ARMColors.primary.withOpacity(.7),
                size: 55.0,
              ),
              const SizedBox(
                width: 7.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ARMText(
                    text: widget.name,
                    color: Colors.blueGrey.shade400,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                  ),
                  ARMText(
                    text: widget.value,
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
