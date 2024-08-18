import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/utils/colors/colors.util.dart';

class ARMUnderlinedTextFormField extends ConsumerStatefulWidget {
  final IconData? icon;
  final IconData? suffixIcon;
  final String hintText;
  final int? maxLine;
  final bool obscureText;
  final String? Function(String?) validator;
  final TextInputType textInputType;
  final void Function(String) onChanged;
  const ARMUnderlinedTextFormField({
    super.key,
    this.icon,
    this.suffixIcon,
    this.maxLine,
    required this.hintText,
    required this.obscureText,
    required this.validator,
    required this.textInputType,
    required this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ARMUnderlinedTextFormFieldState();
}

class _ARMUnderlinedTextFormFieldState
    extends ConsumerState<ARMUnderlinedTextFormField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      cursorColor: ARMColors.primary,
      maxLines: widget.maxLine,
      //   style: const TextStyle(fontFamily: 'Poppins'),
      decoration: InputDecoration(
        icon: Icon(
          widget.icon,
          color: ARMColors.primary,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
        ),
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(showPassword
                    ? /*YaruIcons.hide*/ Icons.hide_source
                    : widget.suffixIcon),
              )
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(width: .5, color: Colors.black45),
          borderRadius: BorderRadius.circular(.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: ARMColors.primary.withOpacity(.5),
          ),
          borderRadius: BorderRadius.circular(.0),
        ),
      ),
      obscureText: showPassword ? false : widget.obscureText,
      validator: (value) => widget.validator(value),
      onChanged: (value) => widget.onChanged(value),
    );
  }
}
