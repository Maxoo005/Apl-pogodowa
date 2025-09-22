import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "/../../features/weather/presentation/weather_providers.dart";


class HourlyStrip extends ConsumerWidget {
  const HourlyStrip({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = ref.watch(weatherHourlyProvider);
    return h.when(
      loading: () => const _Skeleton(),
      error: (e, _) => Padding(padding: const EdgeInsets.all(12), child: Text(e.toString())),
      data: (data) {
        final now = DateTime.now();
        final visible = data.points
            .where((p) => !p.t.isBefore(now.subtract(const Duration(hours: 1))))
            .take(24)
            .toList();

        return SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: visible.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final p = visible[i];
              final hh = TimeOfDay.fromDateTime(p.t).format(context);
              return Container(
                width: 80,
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
                    const SizedBox(height: 8),
                    Text("${p.temperatureC.toStringAsFixed(0)}°"),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => SizedBox(height: 110, child: Center(child: CircularProgressIndicator()));
}
