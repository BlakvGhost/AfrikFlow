import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const CustomDrawer({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              name,
              style: const TextStyle(color: Colors.white54),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(color: Colors.white54),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
            ),
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Partager'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('À propos'),
            onTap: () {},
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Se déconnecter'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
