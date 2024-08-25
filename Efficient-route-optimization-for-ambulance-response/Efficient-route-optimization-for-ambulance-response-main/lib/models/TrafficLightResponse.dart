class TrafficLightResponse {
  late int id;
  late String latitude;
  late String longitude;
  late String locationName;
  late DateTime createdDate;
  late DateTime updatedDate;
  late String status;

  TrafficLightResponse({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.createdDate,
    required this.updatedDate,
    required this.status,
  });
}
