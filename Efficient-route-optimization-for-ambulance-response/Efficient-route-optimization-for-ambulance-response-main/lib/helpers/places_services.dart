import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:map_project/models/TrafficLightResponse.dart';

class PlacesService {
  final key = '';
  //nearby place mfrod shghala
  Future<dynamic> getPlaceDetails(double lat, double lng) async {
    // var lat = coords.latitude;
    // var lng = coords.longitude;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=3000&type=hospital&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }

  Future<dynamic> getMorePlaceDetails(String token) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&pagetoken=$token&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }

  Future<Map<String, dynamic>> getPlace(String? input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  // Future<TrafficLightResponse> getTrafficLight() async {
  //   final String url = 'http://localhost:9090/api/v1/trafficlight';
  //   var response = await http.get(Uri.parse(url));
  //   var json = convert.jsonDecode(response.body);
  //   var results = TrafficLightResponse(
  //   id: json['id'],
  //   latitude: json['latitude'],
  //   longitude: json['longitude'],
  //   locationName: json['locationName'],
  //   createdDate: DateTime.parse(json['createdDate']),
  //   updatedDate: DateTime.parse(json['updatedDate']),
  //    );
  //   return results;

    
  // }
  
}
