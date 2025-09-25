import 'package:flutter/material.dart';

IconData iconForWeatherCode(int code) {
  if (code == 0) return Icons.wb_sunny_outlined;
  if ([1, 2, 3].contains(code)) return Icons.cloud_outlined;
  if ([45, 48].contains(code)) return Icons.foggy; 
  if ([51, 53, 55, 56, 57, 61, 63, 65].contains(code)) return Icons.umbrella_outlined; 
  if ([66, 67, 80, 81, 82].contains(code)) return Icons.grain; 
  if ([71, 73, 75, 77, 85, 86].contains(code)) return Icons.ac_unit_outlined; 
  if ([95, 96, 99].contains(code)) return Icons.thunderstorm_outlined; 
  return Icons.device_thermostat;
}
