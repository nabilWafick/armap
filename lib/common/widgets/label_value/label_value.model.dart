import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';

class LabelValue extends ConsumerWidget {
  final String label;
  final String value;
  final bool? isColumnFormat;
  final double? width;
  final double? labelSize;
  final double? valueSize;
  final FontWeight? labelFontWeight;
  final FontWeight? valueFontWeight;
  const LabelValue({
    super.key,
    required this.label,
    required this.value,
    this.isColumnFormat,
    this.width,
    this.labelSize,
    this.valueSize,
    this.labelFontWeight,
    this.valueFontWeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      child: isColumnFormat == null || isColumnFormat == false
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ARMText(
                  text: '$label: ',
                  fontSize: labelSize ?? 12,
                  fontWeight: labelFontWeight ?? FontWeight.normal,
                ),
                Flexible(
                  child: ARMText(
                    text: value,
                    fontSize: valueSize ?? 12,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: valueFontWeight ?? FontWeight.w500,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ARMText(
                  text: '$label: ',
                  fontSize: labelSize ?? 12,
                  fontWeight: labelFontWeight ?? FontWeight.normal,
                ),
                Flexible(
                  child: ARMText(
                    text: value,
                    fontSize: valueSize ?? 12,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: valueFontWeight ?? FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }
}
