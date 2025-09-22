import "package:flutter_riverpod/flutter_riverpod.dart";
import "weather_providers.dart";

class WeatherState{
  const WeatherState();
}

final weatherCombinedProvider = Provider<AsyncValue<void>>((ref){
  final now = ref.watch(weatherNowProvider);
  final hourly = ref.watch(weatherHourlyProvider);
  final daily = ref.watch(weatherDailyProvider);

  if (now.isLoading || hourly.isLoading || daily.isLoading){
    return const AsyncLoading();
  }
  final errors = [now, hourly, daily].where((a) => a.hasError).toList();
  if (errors.isNotEmpty){
    return AsyncError(errors.first.error!, StackTrace.current);
  }
  return const AsyncData(null);

});