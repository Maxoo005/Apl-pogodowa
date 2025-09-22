import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "/../../features/weather/presentation/weather_providers.dart";

class TopCard extends ConsumerWidget {
  const TopCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(weatherNowProvider);
    return now.when(
      loading: () => const _Shimmer(height: 120),
      error: (e, _) => _Error(text: e.toString()),
      data: (d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Teraz", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text("${d.temperatureC.toStringAsFixed(1)} °C", style: Theme.of(context).textTheme.displaySmall),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.air),
                  const SizedBox(height: 8),
                  Text("${d.windSpeedKmh.toStringAsFixed(0)} km/h"),
                ],
              ),
            ],
          ),
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
  final String text; const _Error({required this.text});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(text)));
}
