import "env.dart";

class ApiPaths {
  static const String baseUrl = Env.apiBase;

  static String forecast({
    required double lat,
    required double lon,
  }) =>
      "/forecast?latitude=$lat&longitude=$lon"
      "&current_weather=true"
      "&hourly=temperature_2m,wind_speed_10m,relative_humidity_2m"
      "&daily=temperature_2m_max,temperature_2m_min"
      "&timezone=auto";
}
