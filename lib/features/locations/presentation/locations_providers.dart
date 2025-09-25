import "dart:convert";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

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

  @override
  bool operator ==(Object other) =>
      other is LocationModel && other.lat == lat && other.lon == lon && other.name == name;

  @override
  int get hashCode => Object.hash(name, lat, lon);
}

const _kSelectedLocation = 'selected_location_v1';

final suggestedLocationsProvider = Provider<List<LocationModel>>((_) => const [
      LocationModel(name: 'Wrocław',  lat: 51.1079, lon: 17.0385),
      LocationModel(name: 'Warszawa', lat: 52.2297, lon: 21.0122),
      LocationModel(name: 'Kraków',   lat: 50.0647, lon: 19.9450),
      LocationModel(name: 'Gdańsk',   lat: 54.3520, lon: 18.6466),
    ]);

class SelectedLocationNotifier extends Notifier<LocationModel> {
  @override
  LocationModel build() {
    _load(); // async, zaktualizuje state gdy wczyta
    return const LocationModel(name: 'Wrocław', lat: 51.1079, lon: 17.0385);
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kSelectedLocation);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      state = LocationModel.fromJson(map);
    }
  }

  Future<void> setLocation(LocationModel loc) async {
    state = loc;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kSelectedLocation, jsonEncode(loc.toJson()));
  }
}

final selectedLocationProvider =
    NotifierProvider<SelectedLocationNotifier, LocationModel>(SelectedLocationNotifier.new);
