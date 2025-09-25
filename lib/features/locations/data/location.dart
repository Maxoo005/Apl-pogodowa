class LocationModel {
  final String name;
  final double lat;
  final double lon;
  const LocationModel({required this.name, required this.lat, required this.lon});

  Map<String, dynamic> toJson() => {'name': name, 'lat': lat, 'lon': lon};
  factory LocationModel.fromJson(Map<String, dynamic> j) => LocationModel(
    name: j['name'] as String,
    lat: (j['lat'] as num).toDouble(),
    lon: (j['lon'] as num).toDouble(),
  );
}
