import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test/common/models/location/location.model.dart';
import 'package:test/utils/utils.dart';

class RoutingService {
  static Future<dynamic> getRoute({
    required Location startPoint,
    required Location endPoint,
    required String travelMode,
  }) async {
    try {
      final startCoord =
          '${startPoint.latLng.longitude},${startPoint.latLng.latitude}';
      final endCoord =
          '${endPoint.latLng.longitude},${endPoint.latLng.latitude}';

      final baseUrl =
          'https://router.project-osrm.org/route/v1/$travelMode/$startCoord;$endCoord';

      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: ARMConstants.connectionTimeoutDuration,
          receiveTimeout: ARMConstants.receiveTimeoutDuration,
        ),
      );

      final response = await dio.get(
        '',
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
          'steps': 'true',
          'annotations': 'true',
          'alternatives': '1',
        },
      );

      return response;
    } on DioException catch (error) {
      if (error.response != null) {
        // server error
        debugPrint(error.response?.data.toString());
      } else {
        // connection error
        debugPrint(error.response.toString());
      }
    }
  }
}
