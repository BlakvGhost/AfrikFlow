import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:afrik_flow/widgets/ui/auth_screen_bottom_cgu.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    String email = "";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 120),
              children: [
                const Center(
                  child: Text(
                    'Connectez-vous!',
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
                      'Vous n\'avez pas de compte?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.whiteColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        context.push('/register');
                      },
                      child: const Text(
                        'Inscrivez-vous',
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
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail/ Numéro de téléphone',
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Mot de passe oublié?'),
                  ),
                ),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  label: 'Se connecter',
                  onPressed: () {
                    context.push('/two-factor-verification', extra: email);
                  },
                  textColor: AppTheme.backgroundColor,
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Ou se connecter avec'),
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
