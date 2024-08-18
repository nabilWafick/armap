import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class DraggableMap extends StatefulHookConsumerWidget {
  const DraggableMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DraggableMapState();
}

class _DraggableMapState extends ConsumerState<DraggableMap> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .25,
      minChildSize: .25,
      builder: (context, scrollController) => SizedBox(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Stack(
            children: [
              ShapeOfView(
                shape: ArcShape(
                  position: ArcPosition.Top,
                  height: 40.0,
                ),
                height: MediaQuery.of(context).size.height,
                child: Container(
                  color: Colors.blueGrey,
                ),
              ),
              Positioned(
                top: 15.0,
                left: MediaQuery.of(context).size.width / 2 - 25,
                child: Container(
                  height: 5,
                  width: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
