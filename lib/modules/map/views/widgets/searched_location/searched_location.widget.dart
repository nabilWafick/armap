import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:test/common/models/location/location.model.dart';
import 'package:test/utils/colors/colors.util.dart';

class SearchedLocation extends StatefulHookConsumerWidget {
  final Location location;
  final VoidCallback onTap;
  const SearchedLocation({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchedLocationState();
}

class _SearchedLocationState extends ConsumerState<SearchedLocation> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          shape: BoxShape.circle,
        ),
        child: const Icon(
          HugeIcons.strokeRoundedLocation01,
          color: ARMColors.primary,
          size: 15.0,
        ),
      ),
      title: Text(
        widget.location.displayName,
      ),
      trailing: const Icon(
        Icons.north_west_outlined,
        color: ARMColors.primary,
        size: 20,
      ),
      onTap: widget.onTap,
    );
  }
}
