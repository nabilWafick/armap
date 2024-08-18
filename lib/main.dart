import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/modules/map/views/pages/map_view/map_view.page.dart';
import 'package:test/utils/utils.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ARMapApp(),
    ),
  );
}

class ARMapApp extends StatelessWidget {
  const ARMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ARMThemeData.lightTheme,
      home: const Scaffold(
        body: MapView(),
        /*  SafeArea(
          child: WidgetView(),
        ),*/
      ),
    );
  }
}
