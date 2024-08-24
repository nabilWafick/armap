import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/widgets/widgets.common.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/utils/utils.dart';

class StepsPage extends StatefulHookConsumerWidget {
  const StepsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StepsPageState();
}

class _StepsPageState extends ConsumerState<StepsPage> {
  @override
  Widget build(BuildContext context) {
    final travelRoute = ref.watch(travelRouteProvider);
    final steps = travelRoute!.steps;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios_new_rounded,
        ),
        title: const ARMText(
          text: 'Steps',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 25.0,
          horizontal: 10.0,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: steps
                .map(
                  (step) => ListTile(
                    style: ListTileStyle.list,
                    leading: Column(
                      children: [
                        Icon(
                          step.icon,
                          size: 20.0,
                          color: ARMColors.primary,
                        ),
                        ARMText(
                          text: step.distance,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                    tileColor: Theme.of(context).scaffoldBackgroundColor,
                    title: ARMText(
                      text: step.instruction,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
