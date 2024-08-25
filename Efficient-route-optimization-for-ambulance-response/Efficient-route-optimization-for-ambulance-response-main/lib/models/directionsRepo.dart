import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_project/env.dart';
import 'package:map_project/models/directions.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required Position origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': GOOGLE_API_KEY,
      },
    );

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }

    return null;
  }
}
