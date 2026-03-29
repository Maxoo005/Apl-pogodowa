import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "/../../features/weather/presentation/weather_providers.dart";

class DailyList extends ConsumerWidget {
  const DailyList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(weatherDailyProvider);
    return d.when(
      loading: () => const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
      error: (e, _) => Padding(padding: const EdgeInsets.all(16), child: Text(e.toString())),
      data: (data) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.days.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final p = data.days[i];
          final dateStr = "${p.day.day}.${p.day.month}";
          return ListTile(
            title: Text(dateStr),
            subtitle: Text("opad: ${p.precipMm.toStringAsFixed(1)} mm"),
            trailing: Text("${p.tMinC.toStringAsFixed(0)}° / ${p.tMaxC.toStringAsFixed(0)}°"),
          );
        },
      ),
    );
  }
}
