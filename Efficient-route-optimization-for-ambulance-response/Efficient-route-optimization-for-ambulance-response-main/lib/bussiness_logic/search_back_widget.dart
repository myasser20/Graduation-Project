import 'package:flutter/material.dart';
import 'package:map_project/helpers/network_utlity.dart';
import 'package:map_project/helpers/ui_helper.dart';
import 'package:map_project/models/auto_complete_prediction.dart';
import 'package:map_project/models/place_auto_complete.dart';

class SearchBackWidget extends StatefulWidget {
  final double currentSearchPercent;

  final Function(bool) animateSearch;

  const SearchBackWidget({
    super.key,
    required this.currentSearchPercent,
    required this.animateSearch,
  });

  @override
  State<SearchBackWidget> createState() => _SearchBackWidgetState();
}

class _SearchBackWidgetState extends State<SearchBackWidget> {
  List<AutoCompletePredication> placePredicates = [];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: realH(53),
      right: realW(27),
      child: Opacity(
        opacity: widget.currentSearchPercent,
        child: Container(
          width: realW(320),
          height: realH(71),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: realW(17)),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  widget.animateSearch(false);
                },
                child: Transform.scale(
                  scale: widget.currentSearchPercent,
                  child: Icon(
                    Icons.arrow_back,
                    size: realW(34),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: realW(30.0)),
                  child: TextFormField(
                    enabled: widget.currentSearchPercent == 1.0,
                    cursorColor: const Color(0xFF707070),
                    decoration: const InputDecoration(
                      hintText: "Search here",
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: realW(22)),
                    onChanged: (query) {},
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: placePredicates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(placePredicates[index].description.toString()),
                      // Add onTap or other functionality as needed
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
