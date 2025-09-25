import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "/../../features/weather/presentation/weather_providers.dart";
import "/../../settings/settings_providers.dart";
import '../../weather/presentation/weather_icons.dart';
//import '../../weather/data/models/weather_now.dart'; 

class HourlyStrip extends ConsumerWidget {
  const HourlyStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowAsync = ref.watch(weatherNowProvider);
    final h = ref.watch(weatherHourlyProvider);
    final isC = ref.watch(isCelsiusProvider);
    final is24 = ref.watch(is24hProvider);

    if (nowAsync.isLoading || h.isLoading) {
      return const _Skeleton();
    }
    if (nowAsync.hasError) {
      return _Err(text: nowAsync.error.toString(), retry: () => ref.invalidate(weatherNowProvider));
    }
    if (h.hasError) {
      return _Err(text: h.error.toString(), retry: () => ref.invalidate(weatherHourlyProvider));
    }

    final now = nowAsync.value!;
    final data = h.value!;
    final t = now.time;
    final startAt = DateTime(t.year, t.month, t.day, t.hour).add(const Duration(hours: 1));
    final startIdx = data.points.indexWhere((p) => !p.t.isBefore(startAt));
    final begin = startIdx >= 0 ? startIdx : 0;
    final end = (begin + 24) <= data.points.length ? (begin + 24) : data.points.length;
    final visible = data.points.sublist(begin, end);

    final fmt = DateFormat(is24 ? 'HH:00' : 'h a');

    return SizedBox(
      height: 125,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final p = visible[i];
          final hh = fmt.format(p.t);
          final temp = toDisplayTemp(p.temperatureC, isC).round();
          final prob = p.precipProb.round();

          return Container(
            width: 90,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(hh, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Icon(iconForWeatherCode(p.weatherCode)),
                const SizedBox(height: 4),
                Text("$temp°"),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.water_drop_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text("$prob%"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) =>
      SizedBox(height: 125, child: Center(child: CircularProgressIndicator()));
}

class _Err extends StatelessWidget {
  final String text; final VoidCallback retry;
  const _Err({required this.text, required this.retry});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: Column(children: [
      Text(text),
      const SizedBox(height: 8),
      OutlinedButton(onPressed: retry, child: const Text('Spróbuj ponownie')),
    ]),
  );
}

