import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "settings_providers.dart";

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isC = ref.watch(isCelsiusProvider);
    final is24 = ref.watch(is24hProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia'),
      leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(children: [
        SwitchListTile(
          value: isC,
          title: const Text('Jednostki temperatury °C / °F'),
          onChanged: (v) => ref.read(isCelsiusProvider.notifier).state = v,
        ),
        SwitchListTile(
          value: is24,
          title: const Text('Format czasu 24h'),
          onChanged: (v) => ref.read(is24hProvider.notifier).state = v,
        ),
      ]),
    );
  }
}
