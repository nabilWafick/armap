import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:test/common/models/search_result/search_result.model.dart';
import 'package:test/common/services/search/search.service.dart';
import 'package:test/modules/map/providers/providers.dart';
import 'package:test/utils/colors/colors.util.dart';

class SearchPage extends StatefulHookConsumerWidget {
  final MapController mapController;
  final bool isSimpleSearch;
  final StateProvider<SearchResult?> locationProvider;
  const SearchPage({
    super.key,
    required this.mapController,
    required this.isSimpleSearch,
    required this.locationProvider,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final SearchService searchService = SearchService();

  final textEditingController = TextEditingController();

  void _handleSearch(String query) async {
    ref.read(isSearchingProvider.notifier).state = true;
    try {
      final results = await searchService.searchPlaces(query);

      ref.read(searchResultsProvider.notifier).state = results;
      ref.read(isSearchingProvider.notifier).state = false;
    } catch (e) {
      ref.read(isSearchingProvider.notifier).state = false;
      debugPrint('Error searching: $e');
    }
  }

  void _selectSearchResult(SearchResult result) {
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

    // Clear search results
    ref.invalidate(searchResultsProvider);

    widget.mapController.move(result.latLng, 15);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

/*
    textEditingController.text =
        ref.read(searchedLocationProvider)?.displayName ?? '';

        */
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final searchResults = ref.watch(searchResultsProvider);

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
              hintText: 'Search for a place',
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
                ref.invalidate(searchResultsProvider);
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
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      HugeIcons.strokeRoundedLocation01,
                      color: ARMColors.primary,
                      size: 15.0,
                    ),
                  ),
                  title: Text(
                    searchResults[index].displayName,
                  ),
                  trailing: const Icon(
                    Icons.north_west_outlined,
                    color: ARMColors.primary,
                    size: 20,
                  ),
                  onTap: () {
                    if (widget.isSimpleSearch) {
                      _selectSearchResult(searchResults[index]);
                    } else {
                      ref.read(widget.locationProvider.notifier).state =
                          searchResults[index];

                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
    );
  }
}
