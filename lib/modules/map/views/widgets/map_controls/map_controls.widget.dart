import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/utils/utils.dart';

class MapControls extends StatefulHookConsumerWidget {
  final VoidCallback onCenterToUser;

  const MapControls({
    super.key,
    required this.onCenterToUser,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapControlsState();
}

class _MapControlsState extends ConsumerState<MapControls> {
  @override
  Widget build(BuildContext context) {
    final controller = MapController.of(context);
    final camera = MapCamera.of(context);
    final toggleMeasureMode = ref.watch(toggleMeasureModeProvider);

    return Positioned(
      bottom: 90.0,
      right: 16.0,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: 'Distance',
            backgroundColor: toggleMeasureMode ? Colors.white : null,
            onPressed: () {},
            child: Icon(
              Icons.social_distance,
              color: toggleMeasureMode ? ARMColors.primary : Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            heroTag: 'Zoom In',
            onPressed: () {
              final zoom = min(camera.zoom + 1, ARMConstants.maxZoom);
              controller.move(
                camera.center,
                zoom,
              );
            },
            child: const Icon(
              Icons.zoom_out_map_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            heroTag: 'Zoom Out',
            onPressed: () {
              final zoom = max(
                camera.zoom - 1,
                ARMConstants.minZoom,
              );
              controller.move(camera.center, zoom);
            },
            child: const Icon(
              Icons.zoom_in_map_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          /*  FloatingActionButton(
            heroTag: 'AR Mode',
            onPressed: () {},
            child: const Icon(
              Icons.view_in_ar_rounded,
              color: Colors.white,
            ),
          )*/
          const SizedBox(
            height: 50.0,
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            heroTag: 'Center To User',
            onPressed: widget.onCenterToUser,
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            heroTag: 'Center To User',
            onPressed: widget.onCenterToUser,
            child: const Icon(
              Icons.directions_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
