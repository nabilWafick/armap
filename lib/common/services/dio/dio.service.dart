import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioService {
  final Dio _dio = Dio();

  Future<dynamic> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  // Add more methods (post, put, delete) as needed
}
