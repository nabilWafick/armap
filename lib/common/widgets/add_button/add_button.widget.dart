import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/utils/colors/colors.util.dart';

class ARMAddButton extends ConsumerWidget {
  final Function() onTap;
  const ARMAddButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: const Card(
          elevation: 5.0,
          color: ARMColors.primary,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                Icons.add_circle,
                color: ARMColors.primary,
              ),
              SizedBox(
                width: 15.0,
              ),
              ARMText(
                text: 'Ajouter',
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: ARMColors.primary,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
