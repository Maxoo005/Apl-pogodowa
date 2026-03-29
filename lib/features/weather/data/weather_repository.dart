import "package:dio/dio.dart";
import "/../../core/dio_client.dart";
import "models/weather_now.dart";
import "models/weather_hourly.dart";
import "models/weather_daily.dart";
import "/../core/api_paths.dart";

class WeatherRepository {
  WeatherRepository({Dio? dio}) : _dio = dio ?? buildDio();
  final Dio _dio;

  Future<Map<String, dynamic>> _fetchAll({
    required double lat,
    required double lon,
  }) async {
    try {
      final url = ApiPaths.forecast(lat: lat, lon: lon);
      final res = await _dio.get(url);
      if (res.statusCode == null || res.statusCode! >= 400) {
        throw Exception('HTTP ${res.statusCode}');
      }
      return (res.data as Map).cast<String, dynamic>();
    } on DioException catch (e) {
      final msg = e.message ?? 'Połączenie nieudane';
      throw Exception('Połączenie nieudane: $msg');
    } catch (_) {
      throw Exception('Błąd pobierania danych');
    }
  }

  Future<WeatherNow> getNow({required double lat, required double lon}) async {
    final data = await _fetchAll(lat: lat, lon: lon);
    return WeatherNow.fromOpenMeteo(data);
  }

  Future<WeatherHourly> getHourly({required double lat, required double lon}) async {
    final data = await _fetchAll(lat: lat, lon: lon);
    return WeatherHourly.fromOpenMeteo(data);
  }

  Future<WeatherDaily> getDaily({required double lat, required double lon}) async {
    final data = await _fetchAll(lat: lat, lon: lon);
    return WeatherDaily.fromOpenMeteo(data);
  }
}
