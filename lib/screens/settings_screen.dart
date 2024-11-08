import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _twoFactorEnabled = false;
  bool _emailUpdatesEnabled = true;
  bool _isLoading = false;
  bool _isGL = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);

    _notificationsEnabled = user?.isAcceptedNotifications ?? false;
    _twoFactorEnabled = user?.isTwoFactorEnabled ?? false;
    _emailUpdatesEnabled = user?.isAcceptedEmailUpdates ?? false;
    _isGL = user?.isGoogleLogin ?? false;
  }

  void _updateSettings() async {
    setState(() {
      _isLoading = true;
    });
    final response = await ApiService().updateUserProfile(
      null,
      null,
      null,
      isTwoFactorEnabled: _twoFactorEnabled,
      isAcceptedNotifications: _notificationsEnabled,
      isAcceptedEmailUpdates: _emailUpdatesEnabled,
      ref: ref,
    );

    setState(() {
      _isLoading = false;
    });

    if (response['success'] && mounted) {
      showSucessToast(context, 'Paramètres mis à jour avec succès.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Text(
            'Géneral',
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
        if (!_isGL) ...[
          _buildSwitchTile(
            'Activer l\'authentification 2FA',
            'Ajouter une couche supplémentaire de sécurité à votre compte.',
            _twoFactorEnabled,
            (value) {
              setState(() {
                _twoFactorEnabled = value;
              });
            },
          )
        ],
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomElevatedButton(
                onPressed: _updateSettings,
                label: "Mise à jour",
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              _buildUtilityButton(
                icon: Icons.help_outline,
                label: 'Aide',
                onPressed: () {
                  context.push('/faq');
                },
              ),
              _buildUtilityButton(
                icon: Icons.share_outlined,
                label: 'Partager l\'app',
                onPressed: () {
                  Share.share(
                      'Découvrez AfrikFlow, cette application incroyable de Transfert d\'argent en Afrique ! https://afrikflow.com');
                },
              ),
              _buildUtilityButton(
                icon: Icons.info_outline,
                label: 'À propos',
                onPressed: () {
                  context.push('/about');
                },
              ),
            ],
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

  Widget _buildUtilityButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
