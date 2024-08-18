import 'package:flutter/material.dart';
import 'package:test/common/widgets/text/text.widget.dart';

class ARMElevatedButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final Function() onPressed;

  const ARMElevatedButton(
      {super.key,
      required this.text,
      this.textColor,
      this.backgroundColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          /* shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(.0),),*/
          //   elevation: 5.0,
          backgroundColor: backgroundColor,
          // minimumSize: const Size(50.0, 45.0),
        ),
        child: ARMText(
          text: text,
          textAlign: TextAlign.center,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
