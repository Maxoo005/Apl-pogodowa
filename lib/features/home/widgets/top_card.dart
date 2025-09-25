import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:intl/intl.dart';
import "../../weather/presentation/weather_providers.dart";
import "../../weather/presentation/weather_icons.dart";
import "../../../settings/settings_providers.dart";
import "../../locations/presentation/locations_providers.dart";
import "../../weather/data/models/weather_hourly.dart";


class TopCard extends ConsumerWidget {
  const TopCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowAsync = ref.watch(weatherNowProvider);
    final hourlyAsync = ref.watch(weatherHourlyProvider);
    final isC = ref.watch(isCelsiusProvider);
    final loc = ref.watch(selectedLocationProvider);

    if (nowAsync.isLoading || hourlyAsync.isLoading) return const _Shimmer(height: 120);
    if (nowAsync.hasError) {
      return _Error(text: nowAsync.error.toString(), onRetry: () => ref.invalidate(weatherNowProvider));
    }
    if (hourlyAsync.hasError) {
      return _Error(text: hourlyAsync.error.toString(), onRetry: () => ref.invalidate(weatherHourlyProvider));
    }

    final now = nowAsync.value!;
    final hourly = hourlyAsync.value!;
    final updateTime = now.time;
    final startAt = DateTime(updateTime.year, updateTime.month, updateTime.day, updateTime.hour).add(const Duration(hours: 1));
    HourlyPoint? start;
    for (final p in hourly.points) {
      if (!p.t.isBefore(startAt)) { start = p; break; }
    }
    start ??= hourly.points.first;
    final precip = (start.precipProb).clamp(0, 100).round();

    final temp = toDisplayTemp(now.temperatureC, isC).toStringAsFixed(1);
    final upd = DateFormat('HH:mm').format(updateTime);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Teraz", style: Theme.of(context).textTheme.titleMedium),
                Text(loc.name, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                Text("$temp °${isC ? 'C' : 'F'}", style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 6),
                Text("Aktualizacja: $upd", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(iconForWeatherCode(now.weatherCode), size: 22),
                    const SizedBox(width: 10),
                    const Icon(Icons.air, size: 20),
                    const SizedBox(width: 4),
                    Text("${now.windSpeedKmh.toStringAsFixed(0)} km/h"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.water_drop_outlined, size: 20),
                    const SizedBox(width: 6),
                    Text("$precip%"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double height; const _Shimmer({required this.height});
  @override
  Widget build(BuildContext context) => Card(child: SizedBox(height: height));
}

class _Error extends StatelessWidget {
  final String text; final VoidCallback? onRetry;
  const _Error({required this.text, this.onRetry});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(text),
        const SizedBox(height: 8),
        if (onRetry != null) OutlinedButton(onPressed: onRetry, child: const Text('Spróbuj ponownie')),
      ]),
    ),
  );
}
