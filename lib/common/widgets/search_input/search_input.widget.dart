import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/utils/colors/colors.util.dart';

class ARMSearchInput extends ConsumerStatefulWidget {
  final String hintText;
  final StateProvider searchProvider;
  const ARMSearchInput({
    super.key,
    required this.hintText,
    required this.searchProvider,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ARMSearchInputState();
}

class _ARMSearchInputState extends ConsumerState<ARMSearchInput> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      child: Form(
        child: TextFormField(
          controller: textEditingController,
          onChanged: (value) {
            ref.read(widget.searchProvider.notifier).state = value;
          },
          decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(
                Icons.search,
                color: ARMColors.primary,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  ref.read(widget.searchProvider.notifier).state = '';
                  textEditingController.clear();
                },
                icon: const Icon(
                  Icons.close,
                  color: ARMColors.primary,
                ),
              )),
        ),
      ),
    );
  }
}
