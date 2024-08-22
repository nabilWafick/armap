// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/utils/colors/colors.util.dart';

class TransportType extends StatefulHookConsumerWidget {
  final String type;
  final IconData icon;
  final String name;

  const TransportType({
    super.key,
    required this.type,
    required this.icon,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransportTypeState();
}

class _TransportTypeState extends ConsumerState<TransportType> {
  @override
  Widget build(BuildContext context) {
    final travelMode = ref.watch(travelModeProvider);
    final routeData = ref.watch(travelRouteProvider);
    return InkWell(
      onTap: () {
        ref.read(travelModeProvider.notifier).state = widget.type;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 7.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: travelMode == widget.type
              ? Border.all(
                  color: ARMColors.primary,
                  width: 2.0,
                )
              : null,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: travelMode == widget.type
                  ? ARMColors.primary
                  : Colors.black87,
              size: 20.0,
            ),
            const SizedBox(
              width: 7.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ARMText(
                  text: widget.name,
                  color: travelMode == widget.type
                      ? Colors.grey.shade600
                      : Colors.grey.shade500,
                  fontSize: 10.0,
                  fontWeight: travelMode == widget.type
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
                widget.type == travelMode && routeData != null
                    ? ARMText(
                        text: routeData.totalDuration,
                        color: travelMode == widget.type
                            ? ARMColors.primary
                            : Colors.black87,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                      )
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
