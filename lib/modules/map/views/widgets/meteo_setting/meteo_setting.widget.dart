import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/text/text.widget.dart';

class MeteoSetting extends StatefulHookConsumerWidget {
  const MeteoSetting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeteoSettingState();
}

class _MeteoSettingState extends ConsumerState<MeteoSetting> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0,
      left: 20.0,
      right: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Colors.white,
            icon: const Icon(
              Icons.cloud,
              color: Colors.black87,
              //  color: ARMColors.primary,
            ),
            label: Container(
              margin: const EdgeInsets.only(
                left: 5.0,
              ),
              child: const ARMText(
                text: '32°',
                color: Colors.black87,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.settings,
              color: Colors.black87,
              //  color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
