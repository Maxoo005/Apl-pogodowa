class DailyPoint{
  final DateTime day;
  final double tMinC;
  final double tMaxC;
  final double precipMm;

  DailyPoint({
    required this.day,
    required this.tMinC,
    required this.tMaxC,
    required this.precipMm,
  });
}

class WeatherDaily {
  final List<DailyPoint> days;
  WeatherDaily(this.days);

  factory WeatherDaily.fromOpenMeteo(Map<String, dynamic> json) {
    final d = json['daily'] as Map<String, dynamic>?;
    final dates = (d?['time'] as List?)?.cast<String>() ?? const [];
    final tmax = (d?['temperature_2m_max'] as List?)?.cast<num>() ?? const [];
    final tmin = (d?['temperature_2m_min'] as List?)?.cast<num>() ?? const [];
    final precip = (d?['precipitation_sum'] as List?)?.cast<num>() ?? const [];

    final n = [dates.length, tmax.length, tmin.length, precip.length].reduce((a, b) => a < b ? a : b);
    final out = <DailyPoint>[];
    for (var i = 0; i < n; i++) {
      out.add(DailyPoint(
        day: DateTime.tryParse(dates[i]) ?? DateTime.now(),
        tMinC: tmin[i].toDouble(),
        tMaxC: tmax[i].toDouble(),
        precipMm: precip[i].toDouble(),
      ));
    }
    return WeatherDaily(out);
  }
}
