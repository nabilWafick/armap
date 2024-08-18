import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';
import 'package:test/utils/colors/colors.util.dart';
//import 'package:yaru_icons/yaru_icons.dart';

class ARMTextFormField extends HookConsumerWidget {
  final TextEditingController? textEditingController;
  final String? label;
  final String? hintText;
  final String? initialValue;
  final bool? enabled;
  final bool isMultilineTextForm;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType textInputType;
  final String? Function(String?, WidgetRef) validator;
  final void Function(String?, WidgetRef) onChanged;
  const ARMTextFormField({
    this.textEditingController,
    super.key,
    this.label,
    this.initialValue,
    this.enabled,
    required this.hintText,
    required this.isMultilineTextForm,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    required this.textInputType,
    required this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPassword = useState<bool>(false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: obscureText
          ? TextFormField(
              controller: textEditingController,
              enabled: enabled,
              initialValue: initialValue,
              keyboardType: textInputType,
              obscureText: showPassword.value ? false : obscureText,
              cursorColor: ARMColors.primary,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                label: label != null
                    ? ARMText(
                        text: label!,
                        // fontSize: 15.0,
                      )
                    : null,
                hintText: hintText,
                prefixIcon: prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color: ARMColors.primary,
                      )
                    : null,
                suffixIcon: suffixIcon != null
                    ? IconButton(
                        onPressed: () {
                          showPassword.value = !showPassword.value;
                        },
                        icon: Icon(
                          showPassword.value ? Icons.visibility : suffixIcon,
                          color: Colors.grey.shade500,
                        ),
                      )
                    : null,
              ),
              validator: (value) {
                return validator(value, ref);
              },
              onChanged: (newValue) {
                onChanged(newValue, ref);
              },
              onSaved: (newValue) {
                onChanged(newValue, ref);
              },
              enableSuggestions: true,
            )
          : TextFormField(
              controller: textEditingController,
              enabled: enabled,
              initialValue: initialValue,
              maxLines: isMultilineTextForm ? 5 : null,
              keyboardType: textInputType,
              obscureText: showPassword.value ? false : obscureText,
              cursorColor: ARMColors.primary,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                label: label != null
                    ? ARMText(
                        text: label!,
                        //   fontSize: 15.0,
                      )
                    : null,
                hintText: hintText,
                prefixIcon: prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color: ARMColors.primary,
                      )
                    : null,
                suffixIcon: suffixIcon != null
                    ? IconButton(
                        onPressed: () {
                          showPassword.value = !showPassword.value;
                        },
                        icon: Icon(
                          showPassword.value
                              ? Icons.visibility_off
                              : suffixIcon,
                          color: Colors.grey.shade500,
                        ),
                      )
                    : null,
              ),
              validator: (value) {
                return validator(value, ref);
              },
              onChanged: (newValue) {
                onChanged(newValue, ref);
              },
              onSaved: (newValue) {
                onChanged(newValue, ref);
              },
              enableSuggestions: true,
            ),
    );
  }
}
