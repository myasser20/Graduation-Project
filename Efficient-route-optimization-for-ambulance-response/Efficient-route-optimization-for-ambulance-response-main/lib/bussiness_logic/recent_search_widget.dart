import 'package:flutter/material.dart';
import 'package:map_project/helpers/network_utlity.dart';
import 'package:map_project/helpers/ui_helper.dart';
import 'package:map_project/models/auto_complete_prediction.dart';
import 'package:map_project/models/place_auto_complete.dart';

class RecentSearchWidget extends StatefulWidget {
  final double currentSearchPercent;

  const RecentSearchWidget({super.key, required this.currentSearchPercent});

  @override
  State<RecentSearchWidget> createState() => _RecentSearchWidgetState();
}

class _RecentSearchWidgetState extends State<RecentSearchWidget> {
List<AutoCompletePredication> placePredicates = [];

  String tokenKey = '';

  void placeautocomplete(String query) async {
    Uri uri = Uri.https("maps.googleapis.com",
        "/maps/api/place/autocomplete/json",
         {
          "input": query,
          "types": "hospital",
          "language": "en",
          "components": "country:eg",
         "key": tokenKey}
         );
    String? response = await NetworkUtlity.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.placeAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredicates = result.predictions!;
        });
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return widget.currentSearchPercent != 0
      ? Positioned(
          top: realH(-(75.0 + 494.0) + (75 + 75.0 + 494.0) * widget.currentSearchPercent),
          left: realW((standardWidth - 320) / 2),
          width: realW(320),
          height: realH(494),
          child: Opacity(
            opacity: widget.currentSearchPercent,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: TextFormField(
                    onChanged: (query) {
                      placeautocomplete(query);
                    },
                  ),
                ),
                ListView.builder(
                  itemCount: placePredicates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(placePredicates[index].description.toString()),
                      // Add onTap or other functionality as needed
                    );
                  },
                ),
              ],
            ),
          ),
        )
      : const Padding(
          padding: EdgeInsets.all(0),
        );
}

}
