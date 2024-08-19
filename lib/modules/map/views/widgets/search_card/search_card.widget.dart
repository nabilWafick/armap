import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/models/search_result/search_result.model.dart';
import 'package:test/modules/map/views/widgets/search/search.page.dart';
import 'package:test/utils/colors/colors.util.dart';

class SearchCard extends StatefulHookConsumerWidget {
  final MapController mapController;
  final String hintText;
  final IconData prefixIcon;
  final Color? prefixIconColor;
  final IconData suffixIcon;
  final Color? suffixIconColor;
  final StateProvider<SearchResult?> locationProvider;
  final bool? isFullyRounded;
  const SearchCard({
    super.key,
    required this.mapController,
    required this.hintText,
    required this.prefixIcon,
    this.prefixIconColor,
    required this.suffixIcon,
    this.suffixIconColor,
    required this.locationProvider,
    this.isFullyRounded,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchCardState();
}

class _SearchCardState extends ConsumerState<SearchCard> {
  @override
  Widget build(BuildContext context) {
    final location = ref.watch(widget.locationProvider);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchPage(
              mapController: widget.mapController,
              isSimpleSearch: false,
              locationProvider: widget.locationProvider,
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
          borderRadius:
              widget.isFullyRounded != null && widget.isFullyRounded == true
                  ? BorderRadius.circular(25.0)
                  : BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  widget.prefixIcon,
                  color: widget.prefixIconColor ?? ARMColors.primary,
                  size: 20.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  location != null ? location.name : widget.hintText,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              widget.suffixIcon,
              color: widget.suffixIconColor ?? ARMColors.primary,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
