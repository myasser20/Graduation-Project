import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_project/constants/my_colors.dart';
import 'package:map_project/helpers/location_helper.dart';
import 'package:flutter/services.dart';
import 'package:map_project/helpers/network_utlity.dart';
import 'dart:ui' as ui;
import 'package:map_project/helpers/places_services.dart';
import 'package:map_project/helpers/ui_helper.dart';
import 'package:map_project/models/TrafficLightResponse.dart';
import 'package:map_project/models/auto_complete_prediction.dart';
import 'package:map_project/models/directions.dart';
import 'package:map_project/models/directionsRepo.dart';
import 'package:map_project/env.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math' as Math;


class Mapscreen extends StatefulWidget {
  const Mapscreen({super.key});

  _MapscreenState createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> with TickerProviderStateMixin {
  static  Position? position;
  final Completer<GoogleMapController> _MapController = Completer();
  static  CameraPosition _MyCurrentLocaioCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );
  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;
  final Set<Circle> _circles = <Circle>{};
  int markerIdCounter = 1;
  Set<Marker> _markers = <Marker>{};
  Set<Marker> _markersDupe = <Marker>{};
  List allFavoritePlaces = [];
  Directions? _info;
  GoogleMapController? _googleMapController;
  LatLng? destination;
  Location? location;
  Marker? _selectedMarker;
  bool isVistedCurrent = false;
  List<TrafficLightResponse> trafficLights = [];
  int counter = 0;
  double nextTrafficLights = 1.0;
   late CameraPosition _currentCameraPosition;
   bool _isAnimating = false;
  
  Future<void> getMyCurrentLocaion() async {
    await LocationHelper.getCurrentLocaion();
    getTrafficLightsByLocation();

    bool flag = true;

    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });

    LatLng currentLocation = LatLng(position!.latitude, position!.longitude);

    TrafficLightResponse currentTrafficLight = trafficLights[counter];
    double distanceToCurrent;
    nextTrafficLights = distanceToCurrent = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        double.parse(currentTrafficLight.latitude),
        double.parse(currentTrafficLight.longitude));
    // nextTrafficLights / 1000;

    print("Traffic light distance: " + distanceToCurrent.toString());

    if (distanceToCurrent < 200 && !isVistedCurrent) {
      print("Traffic light less than 100 now ");
      UpdateTrafficLight(currentTrafficLight.id);
      isVistedCurrent = true;
    } else if (distanceToCurrent > 200 && isVistedCurrent) {
      print("Traffic light more than 100 now ");
      UpdateTrafficLastStatus(currentTrafficLight.id);
      isVistedCurrent = false;
      counter++;
    }

    _setCircle(currentLocation);
  }

  Future<void> UpdateTrafficLight(int id) async {
    final String url =
        'http://${HOST_URL}:9090/api/v1/trafficlight/updateNeighboursToRedAndMainToGreen/$id'; // Assuming this endpoint returns a list of traffic lights
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Traffic light status updated successfully');
      getTrafficLightsByLocation();
    } else {
      print('Failed to update traffic light status: ${response.statusCode}');
    }
  }

  void updateTrafficLights() {}

  Future<void> UpdateTrafficLastStatus(int id) async {
    final String url =
        'http://${HOST_URL}:9090/api/v1/trafficlight/updateNeighboursAndMainToLastStatus/$id'; // Assuming this endpoint returns a list of traffic lights
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Traffic light last status returned successfully');
      getTrafficLightsByLocation();
    } else {
      print('Failed to update traffic light status: ${response.statusCode}');
    }
  }

  

  void listenForLocationUpdates() async {
    await LocationHelper.getCurrentLocaion();
    Geolocator.getPositionStream().listen((Position position) {
      // Call your method whenever the location is updated
      getMyCurrentLocaion();
    });
  }

  @override
  initState() {
    super.initState();
    // getMyCurrentLocaion();
    getTrafficLightsByLocation();
    listenForLocationUpdates();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(_degreesToRadians(lat1)) *
            Math.cos(_degreesToRadians(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);

    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    double distance = earthRadius * c; // Distance in kilometers

    return distance * 1000;
  }

  double _degreesToRadians(double degrees) {
    return degrees * Math.pi / 180;
  }

  void _setCircle(LatLng point) {
    _MapController.future.then((GoogleMapController controller) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12),
      ));
      _circles.add(Circle(
        circleId: const CircleId('raj'),
        center: point,
        fillColor: Colors.blue.withOpacity(0.1),
        radius: 3000,
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ));
      getDirections = false;
      
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  _setNearMarker(LatLng point, String label, List types, String status) async {
    var counter = markerIdCounter++;

    final Uint8List markerIcon;
    markerIcon = await getBytesFromAsset('assets/health-medical.png', 75);
    final directions = await DirectionsRepository()
        .getDirections(origin: position!, destination: point);

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));
    destination = point;
    setState(() {
      _markers.add(marker);
      _info = directions;
    });
  }

  _setTrafficLightIcon(TrafficLightResponse TrafficLight) async {
    var counter = markerIdCounter++;
    final Uint8List markerIcon;
    if (TrafficLight.status == 'GREEN') {
      markerIcon = await getBytesFromAsset('assets/green.png', 75);
    } else {
      markerIcon = await getBytesFromAsset('assets/traffic-lights.png', 75);
    }
    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: LatLng(
            double.parse(
              TrafficLight.latitude,
            ),
            double.parse(TrafficLight.longitude)),
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));

    setState(() {
      _markers.add(marker);
    });
  }

  _setTappedMarker(
      LatLng point, String label, List types, String status) async {
    var counter = markerIdCounter++;

    final Uint8List markerIcon;

    markerIcon = await getBytesFromAsset('assets/health-medical.png', 75);

    final directions = await DirectionsRepository()
        .getDirections(origin: position!, destination: point);

    Marker? marker;
    marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {
          setState(() {
            print('Marker tapped at: $point');
            destination = point;
            _info = directions;
            _selectedMarker = marker;
          });
          _removeAllMarkersExceptSelected(marker!);
        },
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );
        
    setState(() {
      _markers.add(marker!);
      
    });
    
  }

  void _removeAllMarkersExceptSelected(Marker selectedMarker) {
    setState(() {
      _markers.removeWhere((marker) => marker != selectedMarker);
    });
  }
  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _currentCameraPosition = position;
    });}

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0), // Initial center position (will be updated)
        zoom: 12,
      ),
      onCameraMove: _updateCameraPosition,
      polylines: {
        if (_info != null)
          Polyline(
            polylineId: const PolylineId('overview_polyline'),
            color: Colors.red,
            width: 5,
            points: _info!.polylinePoints
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
          ),
      },
      circles: _circles,
      onMapCreated: (GoogleMapController controller) {
        _MapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyCurrentLocation() async {
     
    if (position != null) {
    // Update the _MyCurrentLocaioCameraPosition
    setState(() {
      _MyCurrentLocaioCameraPosition = CameraPosition(
        bearing: 0.0,
        target: LatLng(position!.latitude, position!.longitude),
        tilt: 0.0,
        zoom: 17,
      );
    });

    // Animate the camera to the new position
    final GoogleMapController controller = await _MapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_MyCurrentLocaioCameraPosition),
    );
    _isAnimating = false;
  }
    
    // final GoogleMapController controller = await _MapController.future;
    // controller.animateCamera(
    //     CameraUpdate.newCameraPosition(_MyCurrentLocaioCameraPosition));
  }

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_API_KEY, // Your Google Map Key
      PointLatLng(position!.latitude, position!.longitude),
      PointLatLng(destination!.latitude, destination!.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  /// get currentOffset percent

  Future<List<TrafficLightResponse>> getTrafficLights() async {
    final String url =
        'http://${HOST_URL}:9090/api/v1/trafficlight/location/giza'; // Assuming this endpoint returns a list of traffic lights
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    List<TrafficLightResponse> results = [];
    for (var item in json) {
      results.add(TrafficLightResponse(
        id: item['id'],
        latitude: item['latitude'],
        longitude: item['longitude'],
        locationName: item['locationName'],
        createdDate: DateTime.parse(item['createdDate']),
        updatedDate: DateTime.parse(item['updatedDate']),
        status: item['status'],
      ));
    }
    return results;
  }

  Future<List<TrafficLightResponse>> getNeighboursTrafficLights(int id) async {
    final String url =
        'http://${HOST_URL}:9090/api/v1/trafficlight/getTrafficLightNeighbours/${id}'; // Assuming this endpoint returns a list of traffic lights
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    List<TrafficLightResponse> results = [];
    for (var item in json) {
      results.add(TrafficLightResponse(
        id: item['id'],
        latitude: item['latitude'],
        longitude: item['longitude'],
        locationName: item['locationName'],
        createdDate: DateTime.parse(item['createdDate']),
        updatedDate: DateTime.parse(item['updatedDate']),
        status: item['status'],
      ));
    }
    return results;
  }

  Widget bottomSheetContent() {
    return Container(
        height: 200, // Adjust height as needed
        color: Colors.white,
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              //near hospitals
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          final placesResult = await PlacesService()
                              .getPlaceDetails(
                                  position!.latitude, position!.longitude);
                          List<dynamic> placesWithin =
                              placesResult['results'] as List;
                          allFavoritePlaces = placesWithin;
                          tokenKey = placesResult['next_page_token'] ?? 'none';
                          _markers = {};
                          var firstElement = placesWithin[0];
                          _setNearMarker(
                            LatLng(firstElement['geometry']['location']['lat'],
                                firstElement['geometry']['location']['lng']),
                            firstElement['name'],
                            firstElement['types'],
                            firstElement['business_status'] ?? 'not available',
                          );
                          setState(() {
                            //functionality for yasser

                            _markersDupe = _markers;
                            pressedNear = true;

                            Navigator.pop(context); // Close bottom sheet
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(42, 147, 213, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        icon: Container(
                          child: const Icon(
                            Icons.near_me_outlined,
                            color: Colors.white,
                          ),
                        ),
                        label: const Text(
                          "Nearest Hospital",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ))),
              ),

              const SizedBox(
                height: 10,
              ),

              //close hospitals
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final placesResult = await PlacesService()
                          .getPlaceDetails(
                              position!.latitude, position!.longitude);
                      List<dynamic> placesWithin =
                          placesResult['results'] as List;
                      allFavoritePlaces = placesWithin;
                      // tokenKey = placesResult['next_page_token'] ?? 'none';
                      _markers = {};
                      for (final firstElement in placesWithin) {
                        _setTappedMarker(
                          LatLng(firstElement['geometry']['location']['lat'],
                              firstElement['geometry']['location']['lng']),
                           firstElement['name'],
                          firstElement['types'],
                          firstElement['business_status'] ?? 'not available',
                        );
                      }
                      setState(() {
                        //functionality for yasser

                        _markersDupe = _markers;
                        pressedNear = true;
                        Navigator.pop(context); // Close bottom sheet
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(42, 147, 213, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    icon: const Icon(
                      Icons.local_hospital_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Suggested Hospitals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            //functionality for yasser
                            _goToMyCurrentLocation();
                            Navigator.pop(context); // Close bottom sheet
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(42, 147, 213, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Current Location",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ))),
              ),
            ],
          ),
        ));
  }

  void updateDistanceDuration(LatLng currentLocation, LatLng destination) {
    currentLocation = LatLng(position!.latitude, position!.longitude)!;

    setState(() {
      _info!.updateDistanceDuration(currentLocation, destination);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if (_info != null) {
      updateDistanceDuration(
          LatLng(position!.latitude, position!.longitude), destination!);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          position != null
              ? buildMap()
              : Center(
                  child: Container(
                    child: const CircularProgressIndicator(
                      color: MyColors.blue,
                    ),
                  ),
                ),
          Positioned(
            top: 700,
            bottom: 60,
            left: 145,
            child: Container(
              width: 120,
              height: 10,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(42, 147, 213, 1.0),
                    Colors.lightBlueAccent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                shape: BoxShape.circle, // Set the shape to circle
              ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return bottomSheetContent(); // Call your widget function here
                    },
                    isScrollControlled: true, // Enable scrolling if needed
                    backgroundColor: Colors.grey[200], // Set background color
                    shape: const RoundedRectangleBorder(
                        // Customize corner radius
                        ),
                  );
                },
                child: const Center(
                  child: Icon(
                    Icons.location_on, // Replace with your desired icon
                    color: Colors.white,
                    size: 50, // Adjust color as needed
                  ),
                ),
              ),
            ),
          ),
          if (_info != null)
            Positioned(
              top: 160.0,
              left: 80,
              child: Container(
                width: 250,
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(42, 147, 213, 1.0),
                      Colors.lightBlueAccent
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    '${_info!.totalDistance}, ${_info!.totalDuration}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'poppins',
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          
        ],
      ),
    );
  }

  void getTrafficLightsByLocation() async {
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });

    LatLng currentLocation = LatLng(position!.latitude, position!.longitude);
    trafficLights = await getTrafficLights();
    print("trafficLights returned successfully ");

    trafficLights.sort((a, b) => calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            double.parse(a.latitude),
            double.parse(a.longitude))
        .compareTo(calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            double.parse(b.latitude),
            double.parse(b.longitude))));

    counter = 0;
    setTrafficLightsIcons();
  }

  void setTrafficLightsIcons() {
    for (int i = 0; i < trafficLights.length; i++) {
      final trafficLight = trafficLights[i];
      _setTrafficLightIcon(trafficLight);
    }
  }
}
