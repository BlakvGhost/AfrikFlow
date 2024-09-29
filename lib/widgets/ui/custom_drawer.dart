import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
            leading: const PhIcon(
                child: PhosphorIconsDuotone.userCircleGear, isWhite: true),
            title: const Text('Profil'),
            onTap: () {},
          ),
          ListTile(
            leading:
                const PhIcon(child: PhosphorIconsDuotone.gear, isWhite: true),
            title: const Text('Paramètres'),
            onTap: () {},
          ),
          ListTile(
            leading: const PhIcon(
                child: PhosphorIconsDuotone.bellSimpleRinging, isWhite: true),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const PhIcon(
                child: PhosphorIconsDuotone.shareNetwork, isWhite: true),
            title: const Text('Partager'),
            onTap: () {},
          ),
          ListTile(
            leading:
                const PhIcon(child: PhosphorIconsDuotone.info, isWhite: true),
            title: const Text('À propos'),
            onTap: () {},
          ),
          const Spacer(),
          ListTile(
            leading: const PhIcon(
                child: PhosphorIconsDuotone.userSwitch, isWhite: true),
            title: const Text('Se déconnecter'),
            onTap: () {
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
