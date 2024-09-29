import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/ui/auth_screen_bottom_cgu.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  String? selectedCountry;

  final List<Map<String, String>> countries = [
    {'code': '+224', 'name': 'Mali', 'flag': '🇲🇱'},
    {'code': '+225', 'name': 'Côte d’Ivoire', 'flag': '🇨🇮'},
    {'code': '+231', 'name': 'Sénégal', 'flag': '🇸🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    String email = "";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 50),
              children: [
                const Center(
                  child: Text(
                    'Inscrivez-vous!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Déjà inscrit?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.whiteColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        context.push('/login');
                      },
                      child: const Text(
                        'Connectez-vous',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.whiteColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  value: selectedCountry,
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez le pays',
                    border: OutlineInputBorder(),
                  ),
                  items: countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: Row(
                        children: [
                          Text(country['flag']!),
                          const SizedBox(width: 8),
                          Text('${country['name']} (${country['code']})'),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 20),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    suffixIcon: PhIcon(child: PhosphorIconsDuotone.eye),
                  ),
                ),
                const SizedBox(height: 20),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmer mot de passe',
                    border: OutlineInputBorder(),
                    suffixIcon: PhIcon(child: PhosphorIconsDuotone.eye),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    context.go('/email-verification', extra: email);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'S\'inscrire',
                    style: TextStyle(
                        fontSize: 16, color: AppTheme.backgroundColor),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Ou s\'inscrire avec'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const PhIcon(child: PhosphorIconsDuotone.googleLogo),
                  label: const Text('Google'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const AuthScreenBottomCgu()
        ],
      ),
    );
  }
}
