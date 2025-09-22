import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Pogoda'),
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('Lokalizacje (wkrótce)'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ustawienia (wkrótce)'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
