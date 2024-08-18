import 'package:flutter/material.dart';
import 'package:test/common/widgets/text/text.widget.dart';

class ARMTextButton extends ARMText {
  final Function() onPressed;
  const ARMTextButton({
    super.key,
    required super.text,
    super.textAlign,
    super.fontSize,
    super.fontWeight,
    super.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Poppins',
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
