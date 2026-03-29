import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "../../weather/presentation/weather_providers.dart";
import "/../../settings/settings_providers.dart";
import "../../weather/presentation/weather_icons.dart";

class DailyList extends ConsumerWidget {
  const DailyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(weatherDailyProvider);
    final isC = ref.watch(isCelsiusProvider);

    return d.when(
      loading: () =>
          const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(e.toString()),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => ref.invalidate(weatherDailyProvider),
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ),
      data: (data) {
        final days = data.days.take(15).toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final p = days[i];
            final dow = DateFormat.E('pl_PL').format(p.day);
            final dateStr = DateFormat('dd.MM').format(p.day);
            final tMin = toDisplayTemp(p.tMinC, isC).round();
            final tMax = toDisplayTemp(p.tMaxC, isC).round();

            return ListTile(
              leading: Icon(iconForWeatherCode(p.weatherCode)),
              title: Text("$dow  $dateStr"),
              subtitle: Text("opad: ${p.precipMm.toStringAsFixed(1)} mm"),
              trailing: Text("$tMin° / $tMax°"),
            );
          },
        );
      },
    );
  }
}
