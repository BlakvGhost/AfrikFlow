import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _twoFactorEnabled = false;
  bool _emailUpdatesEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Text(
            'Paramètres',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        ),
        _buildSwitchTile(
          'Activer les notifications',
          'Recevoir des notifications push pour vos transactions.',
          _notificationsEnabled,
          (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          'Activer l\'authentification 2FA',
          'Ajouter une couche supplémentaire de sécurité à votre compte.',
          _twoFactorEnabled,
          (value) {
            setState(() {
              _twoFactorEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          'Mises à jour par e-mail',
          'Recevoir des mises à jour importantes et des offres spéciales.',
          _emailUpdatesEnabled,
          (value) {
            setState(() {
              _emailUpdatesEnabled = value;
            });
          },
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Action à réaliser lors de la sauvegarde
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres mis à jour.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Center(
              child: Text(
                'Enregistrer',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.tealAccent[700],
            inactiveThumbColor: Colors.grey[700],
            inactiveTrackColor: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}
