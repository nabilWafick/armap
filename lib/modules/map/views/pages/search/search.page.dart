import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/common/models/location/location.model.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/modules/map/views/widgets/searched_location/searched_location.widget.dart';
import 'package:test/utils/colors/colors.util.dart';
import 'package:test/modules/map/controllers/search/search.controller.dart';

class SearchPage extends StatefulHookConsumerWidget {
  final MapController mapController;
  final String hintText;
  final bool isSimpleSearch;
  final StateProvider<Location?> locationProvider;
  const SearchPage({
    super.key,
    required this.mapController,
    required this.hintText,
    required this.isSimpleSearch,
    required this.locationProvider,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final textEditingController = TextEditingController();

  void _handleSearch(String query) async {
    ref.read(isSearchingProvider.notifier).state = true;
    try {
      final results = await PlaceController.searchPlaces(query: query);

      ref.read(searchedLocationsProvider.notifier).state = results;

      if (!widget.isSimpleSearch) {
        final startPoint = ref.watch(startPointProvider);
        final endPoint = ref.watch(endPointProvider);
        final currentPosition = ref.watch(currentUserLocationProvider);

        if (startPoint?.latLng != currentPosition?.latLng &&
            endPoint?.latLng != currentPosition?.latLng) {}
      }

      ref.read(isSearchingProvider.notifier).state = false;
    } catch (e) {
      ref.read(isSearchingProvider.notifier).state = false;
      debugPrint('Error searching: $e');
    }
  }

  void _selectSearchResult(Location result) {
    // define result
    ref.read(widget.locationProvider.notifier).state = result;

    ref.read(markersProvider.notifier).state = [
      Marker(
        point: result.latLng,
        width: 80,
        height: 80,
        child: const Icon(
          Icons.location_on,
          color: Colors.blue,
        ),
      ),
    ];

    widget.mapController.move(result.latLng, 15);
  }

  @override
  void initState() {
    super.initState();

    textEditingController.text =
        ref.read(searchedLocationProvider)?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final searchedLocations = ref.watch(searchedLocationsProvider);

    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          leadingWidth: .0,
          title: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 45.0,
            child: TextField(
              controller: textEditingController,
              cursorColor: ARMColors.primary,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 14.0,
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 17.0,
                  ),
                ),
                suffixIcon: const Icon(
                  Icons.close,
                  size: 17.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                  borderSide: const BorderSide(
                    color: ARMColors.primary,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _handleSearch(value);
                } else {
                  ref.invalidate(searchedLocationsProvider);
                }
              },
            ),
          ),
        ),
        body: isSearching
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: searchedLocations
                      .map((searchedLocation) => SearchedLocation(
                            location: searchedLocation,
                            onTap: () {
                              if (widget.isSimpleSearch) {
                                _selectSearchResult(searchedLocation);
                              } else {
                                ref
                                    .read(widget.locationProvider.notifier)
                                    .state = searchedLocation;
                              }
                              // Clear search results
                              ref.invalidate(searchedLocationsProvider);

                              // pop page
                              Navigator.of(context).pop();
                            },
                          ))
                      .toList(),
                ),
              ));
  }
}
