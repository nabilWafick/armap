import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WidgetView extends ConsumerWidget {
  const WidgetView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // RouteConfigurationForm(),
        ],
      ),
    );
  }
}
