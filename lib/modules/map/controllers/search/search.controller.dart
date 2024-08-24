import 'package:test/common/models/location/location.model.dart';
import 'package:test/modules/map/services/search/search.service.dart';

class PlaceController {
  static Future<List<Location>> searchPlaces({required String query}) async {
    final response = await PlaceService.searchPlaces(query: query);

    final locations = response != null
        ? (response.data as List)
            .map(
              (item) => Location.fromJson(item),
            )
            .toList()
        : <Location>[];
    return locations;
  }
}
