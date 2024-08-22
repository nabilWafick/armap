import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/utils/utils.dart';

class ARMIconButton extends ConsumerWidget {
  final IconData icon;
  final String text;
  final bool? light;
  final Function() onTap;

  const ARMIconButton({
    super.key,
    required this.icon,
    required this.text,
    this.light,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3.0,
        color: ARMColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              ARMText(
                text: text,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
