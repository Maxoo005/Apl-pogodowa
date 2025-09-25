class HourlyPoint {
  final DateTime t;
  final double temperatureC;
  final double humidity;
  final double windSpeed;
  final double precipProb; 
  final int weatherCode;   

  HourlyPoint({
    required this.t,
    required this.temperatureC,
    required this.humidity,
    required this.windSpeed,
    required this.precipProb,
    required this.weatherCode,
  });
}

class WeatherHourly {
  final List<HourlyPoint> points;
  WeatherHourly(this.points);

  factory WeatherHourly.fromOpenMeteo(Map<String, dynamic> json) {
    final h = json['hourly'] as Map<String, dynamic>?;
    final times = (h?['time'] as List?)?.cast<String>() ?? const [];
    final temps = (h?['temperature_2m'] as List?)?.cast<num>() ?? const [];
    final hums  = (h?['relative_humidity_2m'] as List?)?.cast<num>() ?? const [];
    final winds = (h?['wind_speed_10m'] as List?)?.cast<num>() ?? const [];
    final probs = (h?['precipitation_probability'] as List?)?.cast<num>() ?? const [];
    final codes = (h?['weathercode'] as List?)?.cast<num>() ?? const [];

    final n = [times.length, temps.length, hums.length, winds.length, probs.length, codes.length]
        .reduce((a, b) => a < b ? a : b);

    final pts = <HourlyPoint>[];
    for (var i = 0; i < n; i++) {
      pts.add(HourlyPoint(
        t: DateTime.tryParse(times[i]) ?? DateTime.now(),
        temperatureC: temps[i].toDouble(),
        humidity: hums[i].toDouble(),
        windSpeed: winds[i].toDouble(),
        precipProb: probs[i].toDouble(),
        weatherCode: codes[i].toInt(),
      ));
    }
    return WeatherHourly(pts);
  }
}
