import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_project/models/directionsRepo.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  String totalDistance;
  String totalDuration;

  Directions({
    required this.totalDuration,
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) {}

    final data = Map<String, dynamic>.from(map['routes'][0]);
    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }

  void updateDistanceDuration(LatLng currentLocation, LatLng destination) {
    double newDistance = calculateDistance(currentLocation, destination);
    int newDuration = calculateDuration(newDistance);
    this.totalDistance = '${newDistance.toStringAsFixed(1)} KM';
    this.totalDuration = '$newDuration minutes';
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
            start.latitude, start.longitude, end.latitude, end.longitude) / 1000;
  }

  int calculateDuration(double distance) {
    double hours = distance / 40; // Assuming an average speed of 5 km/h
    int minutes = (hours * 60).round(); // Convert hours to minutes
    return minutes; // Assuming an average speed of 5 km/h
  }

  StreamSubscription<Position>? _positionStream;
  Directions? _directions;
  final DirectionsRepository _repository = DirectionsRepository();

  void startTracking({
    required LatLng destination,
  }) {
    _positionStream?.cancel();
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      final currentLocation = LatLng(position.latitude, position.longitude);
      if (_directions != null) {
        _directions!.updateDistanceDuration(currentLocation, destination);
      } else {
        _repository
            .getDirections(origin: position, destination: destination)
            .then((directions) {
          _directions = directions;
        });
      }
    });
  }

  
}

