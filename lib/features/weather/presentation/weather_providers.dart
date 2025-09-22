import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../weather/data/weather_repository.dart';
import '../../weather/data/models/weather_now.dart';
import '../../weather/data/models/weather_hourly.dart';
import '../../weather/data/models/weather_daily.dart';

final latitudeProvider = Provider<double>((_) => 51.1079);
final longitudeProvider = Provider<double>((_) => 17.0385);

final weatherRepoProvider = Provider<WeatherRepository>((ref) => WeatherRepository());

final weatherNowProvider = FutureProvider<WeatherNow>((ref) async {
  final repo = ref.watch(weatherRepoProvider);
  final lat = ref.watch(latitudeProvider);
  final lon = ref.watch(longitudeProvider);
  return repo.getNow(lat: lat, lon: lon);
});

final weatherHourlyProvider = FutureProvider<WeatherHourly>((ref) async {
  final repo = ref.watch(weatherRepoProvider);
  final lat = ref.watch(latitudeProvider);
  final lon = ref.watch(longitudeProvider);
  return repo.getHourly(lat: lat, lon: lon);
});

final weatherDailyProvider = FutureProvider<WeatherDaily>((ref) async {
  final repo = ref.watch(weatherRepoProvider);
  final lat = ref.watch(latitudeProvider);
  final lon = ref.watch(longitudeProvider);
  return repo.getDaily(lat: lat, lon: lon);
});
