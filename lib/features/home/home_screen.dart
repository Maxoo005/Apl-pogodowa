import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "/../features/weather/presentation/weather_controller.dart";
import "widgets/top_card.dart";
import "widgets/hourly_strip.dart";
import "widgets/daily_list.dart";
import "/../features/locations/presentation/app_drawer.dart";
import "../weather/presentation/weather_providers.dart";


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combined = ref.watch(weatherCombinedProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pogoda')),
      drawer: const AppDrawer(),
      body: combined.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (_) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(weatherCombinedProvider);
            ref.invalidate(weatherNowProvider);
            ref.invalidate(weatherHourlyProvider);
            ref.invalidate(weatherDailyProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: const [
              TopCard(),
              SizedBox(height: 12),
              HourlyStrip(),
              SizedBox(height: 12),
              DailyList(),
            ],
          ),
        ),
      ),
    );
  }
}
