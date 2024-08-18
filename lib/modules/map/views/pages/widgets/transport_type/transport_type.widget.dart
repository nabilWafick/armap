// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/utils/colors/colors.util.dart';

final selectedTranssportTypeProvider = StateProvider<int>((ref) {
  return 0;
});

class TransportType extends StatefulHookConsumerWidget {
  final int index;
  final IconData icon;
  final String name;
  final String duration;
  final Function() onTap;
  const TransportType({
    super.key,
    required this.index,
    required this.icon,
    required this.name,
    required this.duration,
    required this.onTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransportTypeState();
}

class _TransportTypeState extends ConsumerState<TransportType> {
  @override
  Widget build(BuildContext context) {
    final selectedTransporType = ref.watch(selectedTranssportTypeProvider);
    return InkWell(
      onTap: () {
        widget.onTap();
        ref.read(selectedTranssportTypeProvider.notifier).state = widget.index;
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
          border: selectedTransporType == widget.index
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
              color: selectedTransporType == widget.index
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
                  color: selectedTransporType == widget.index
                      ? Colors.grey.shade600
                      : Colors.grey.shade500,
                  fontSize: 10.0,
                  fontWeight: selectedTransporType == widget.index
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
                /*  ARMText(
                  text: widget.duration,
                  color: selectedTransporType == widget.index
                      ? ARMColors.primary
                      : Colors.black87,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                ),
              */
              ],
            )
          ],
        ),
      ),
    );
  }
}
