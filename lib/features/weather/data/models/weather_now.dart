class WeatherNow {
  final double temperatureC;
  final double windSpeedKmh;
  final int weatherCode;
  final DateTime time;

  WeatherNow({
    required this.temperatureC,
    required this.windSpeedKmh,
    required this.weatherCode,
    required this.time,
  });

  factory WeatherNow.fromOpenMeteo(Map<String, dynamic> json) {
    final cw = json['current_weather'] as Map<String, dynamic>?;
    return WeatherNow(
      temperatureC: (cw?['temperature'] as num?)?.toDouble() ?? 0,
      windSpeedKmh: (cw?['windspeed'] as num?)?.toDouble() ?? 0,
      weatherCode: (cw?['weathercode'] as num?)?.toInt() ?? 0,
      time: DateTime.tryParse(cw?['time']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
