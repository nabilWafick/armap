import 'package:flutter/material.dart';

class ARMText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;
  final TextOverflow? textOverflow;

  const ARMText({
    super.key,
    required this.text,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: 3,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
