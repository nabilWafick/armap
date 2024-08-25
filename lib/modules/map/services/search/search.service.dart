import 'package:dio/dio.dart';

class PlaceService {
  static Future<dynamic> searchPlaces({required String query}) async {
    final Dio dio = Dio();
    const baseUrl = 'https://nominatim.openstreetmap.org/search';

    try {
      final response = await dio.get(
        baseUrl,
        queryParameters: {
          'q': query.trim(),
          'format': 'json',
          'limit': '15',
        },
      );

      return response.data;
    } catch (e) {
      throw Exception('Error searching places: $e');
    }
  }
}
