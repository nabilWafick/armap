import 'package:dio/dio.dart';
import 'package:test/common/models/location/location.model.dart';

class SearchService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<Location>> searchPlaces(String query) async {
    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': '15',
        },
      );

      if (response.statusCode == 200) {
        //   debugPrint(response.data.toString());

        return (response.data as List)
            .map(
              (item) => Location.fromJson(item),
            )
            .toList();
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Error searching places: $e');
    }
  }
}
