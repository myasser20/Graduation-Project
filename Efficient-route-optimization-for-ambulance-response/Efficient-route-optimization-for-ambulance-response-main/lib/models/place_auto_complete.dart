import 'dart:convert';

import 'package:map_project/models/auto_complete_prediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutoCompletePredication>? predictions;
  PlaceAutocompleteResponse({
    this.status,
    this.predictions,
  });
  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
        status: json['status'] as String,
        predictions: json['predictions'] != null ? json['predictions']
                .map<AutoCompletePredication>(
                    (json) => AutoCompletePredication.fromJson(json))
                .toList()
            : null);
  }

  static PlaceAutocompleteResponse placeAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}
