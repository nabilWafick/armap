import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test/common/models/search_result/search_result.model.dart';

class SearchService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<SearchResult>> searchPlaces(String query) async {
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
        debugPrint(response.data.toString());

        return (response.data as List)
            .map(
              (item) => SearchResult.fromJson(item),
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
