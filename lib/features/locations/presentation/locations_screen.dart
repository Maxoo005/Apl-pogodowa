import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "../../weather/presentation/weather_providers.dart";
import "locations_providers.dart";

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedLocationProvider);
    final list = ref.watch(suggestedLocationsProvider);

    final containsSelected = list.contains(selected);

    return Scaffold(
      appBar: AppBar(title: const Text('Lokalizacje')),
      body: ListView(
        children: [
          if (!containsSelected) // pokaż bieżącą własną lokalizację
            RadioListTile<LocationModel>(
              value: selected,
              groupValue: selected,
              onChanged: (_) {},
              title: Text('${selected.name} (bieżąca)'),
              subtitle: Text(
                '${NumberFormat("0.0000").format(selected.lat)}, '
                '${NumberFormat("0.0000").format(selected.lon)}',
              ),
            ),
          for (final l in list)
            RadioListTile<LocationModel>(
              value: l,
              groupValue: selected,
              onChanged: (v) async {
                if (v == null) return;
                await ref.read(selectedLocationProvider.notifier).setLocation(v);
                ref.invalidate(weatherNowProvider);
                ref.invalidate(weatherHourlyProvider);
                ref.invalidate(weatherDailyProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Wybrano: ${v.name}')),
                );
              },
              title: Text(l.name),
              subtitle: Text(
                '${NumberFormat("0.0000").format(l.lat)}, '
                '${NumberFormat("0.0000").format(l.lon)}',
              ),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_location_alt_outlined),
            title: const Text('Dodaj własne współrzędne'),
            onTap: () async {
              final res = await showDialog<LocationModel>(
                context: context,
                builder: (_) => const _AddLocationDialog(),
              );
              if (res != null) {
                await ref.read(selectedLocationProvider.notifier).setLocation(res);
                ref.invalidate(weatherNowProvider);
                ref.invalidate(weatherHourlyProvider);
                ref.invalidate(weatherDailyProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dodano: ${res.name}')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AddLocationDialog extends StatefulWidget {
  const _AddLocationDialog();

  @override
  State<_AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<_AddLocationDialog> {
  final name = TextEditingController();
  final lat  = TextEditingController();
  final lon  = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowa lokalizacja'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nazwa (np. Dom)'),
            ),
            TextFormField(
              controller: lat,
              decoration: const InputDecoration(labelText: 'Szerokość (lat)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              validator: (v) => double.tryParse(v ?? '') == null ? 'Podaj liczbę' : null,
            ),
            TextFormField(
              controller: lon,
              decoration: const InputDecoration(labelText: 'Długość (lon)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              validator: (v) => double.tryParse(v ?? '') == null ? 'Podaj liczbę' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anuluj')),
        FilledButton(
          onPressed: () {
            if (_form.currentState!.validate()) {
              Navigator.pop(
                context,
                LocationModel(
                  name: name.text.isEmpty ? 'Własne' : name.text,
                  lat: double.parse(lat.text),
                  lon: double.parse(lon.text),
                ),
              );
            }
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
