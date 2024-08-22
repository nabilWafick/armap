import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/widgets.common.dart';
import 'package:test/modules/map/providers/providers.dart';

class StepsPage extends StatefulHookConsumerWidget {
  const StepsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StepsPageState();
}

class _StepsPageState extends ConsumerState<StepsPage> {
  @override
  Widget build(BuildContext context) {
    final travelRoute = ref.watch(travelRouteProvider);
    final instructions = travelRoute!.instructions;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 10.0,
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: instructions.length,
        itemBuilder: (context, index) => ListTile(
          title: ARMText(
            text: instructions[index],
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
