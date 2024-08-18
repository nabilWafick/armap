import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:test/modules/map/views/widgets/search/search.page.dart';
import 'package:test/utils/colors/colors.util.dart';

class SearchCard extends StatefulHookConsumerWidget {
  final MapController mapController;
  final String locationType;
  const SearchCard(
      {super.key, required this.mapController, required this.locationType});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchCardState();
}

class _SearchCardState extends ConsumerState<SearchCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchPage(
              mapController: widget.mapController,
              isSimpleSearch: false,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedLocation01,
                  color: ARMColors.primary,
                  size: 20.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  widget.locationType,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Colors.blue,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
