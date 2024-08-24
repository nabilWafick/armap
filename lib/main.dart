import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/modules/map/views/pages/map_view/map_view.page.dart';
import 'package:test/utils/utils.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: child!,
      ),
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
