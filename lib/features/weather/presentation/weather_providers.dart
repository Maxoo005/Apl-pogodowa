import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../weather/data/weather_repository.dart";
import "../../weather/data/models/weather_now.dart";
import "../../weather/data/models/weather_hourly.dart";
import "../../weather/data/models/weather_daily.dart";
import "../../locations/presentation/locations_providers.dart";

final weatherRepoProvider = Provider<WeatherRepository>((ref) => WeatherRepository());

final weatherNowProvider = FutureProvider<WeatherNow>((ref) async {
  final repo = ref.watch(weatherRepoProvider);
  final loc = ref.watch(selectedLocationProvider);
  return repo.getNow(lat: loc.lat, lon: loc.lon);
});

final weatherHourlyProvider = FutureProvider<WeatherHourly>((ref) async {
  final repo = ref.watch(weatherRepoProvider);
  final loc = ref.watch(selectedLocationProvider);
  return repo.getHourly(lat: loc.lat, lon: loc.lon);
});

final weatherDailyProvider = FutureProvider<WeatherDaily>((ref) async {
  final repo = ref.watch(weatherRepoProvider);
  final loc = ref.watch(selectedLocationProvider);
  return repo.getDaily(lat: loc.lat, lon: loc.lon);
});
