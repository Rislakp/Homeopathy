import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("White Coat Academy"),
            accountEmail: Text("ADMIN PORTAL"),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Students"),
            onTap: () {
              Navigator.pop(context);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => const StudentScreen(),
              //   ),
              // );
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => const SettingsScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
