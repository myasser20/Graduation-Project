import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> getCurrentLocaion() async {
    bool isServicedEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServicedEnabled) {
      await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
