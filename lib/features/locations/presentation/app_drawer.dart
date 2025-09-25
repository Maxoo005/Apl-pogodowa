import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('Pogoda')),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('Lokalizacje'),
            onTap: () {
              Navigator.of(context).pop();        
              context.push('/locations');         
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ustawienia'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/settings');          
            },
          ),
        ],
      ),
    );
  }
}
