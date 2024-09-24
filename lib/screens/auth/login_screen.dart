import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre
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

          // Lien Inscrivez-vous
          Center(
            child: GestureDetector(
              onTap: () {
                // Logique pour s'inscrire
              },
              child: const Text(
                'Vous n\'avez pas de compte ? Inscrivez-vous',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Champ E-mail / Numéro de téléphone
          const TextField(
            decoration: InputDecoration(
              labelText: 'E-mail/ Numéro de téléphone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          // Champ Mot de passe
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              border: OutlineInputBorder(),
              suffixIcon: PhIcon(child: PhosphorIconsDuotone.eye),
            ),
          ),

          // Lien Mot de passe oublié
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Logique pour mot de passe oublié
              },
              child: const Text('Mot de passe oublié?'),
            ),
          ),
          const SizedBox(height: 10),

          // Bouton Se connecter
          ElevatedButton(
            onPressed: () {
              // Logique de connexion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              'Se connecter',
              style: TextStyle(fontSize: 16, color: AppTheme.backgroundColor),
            ),
          ),
          const SizedBox(height: 20),

          // Ligne ou se connecter avec
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

          // Bouton Google
          ElevatedButton.icon(
            onPressed: () {
              // Logique de connexion avec Google
            },
            icon: const PhIcon(child: PhosphorIconsDuotone.googleLogo),
            label: const Text('Google'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),

          // Texte de bas de page
          const Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'En vous inscrivant vous acceptez notre '),
                  TextSpan(
                    text: 'politique de confidentialité',
                    style: TextStyle(decoration: TextDecoration.underline),
                    // Action lors du clic
                  ),
                  TextSpan(text: ' & '),
                  TextSpan(
                    text: 'Nos termes et conditions.',
                    style: TextStyle(decoration: TextDecoration.underline),
                    // Action lors du clic
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
