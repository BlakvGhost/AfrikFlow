import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/input/password_input_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:afrik_flow/widgets/ui/auth_screen_bottom_cgu.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:afrik_flow/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/providers/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showToast(context, "Veuillez remplir tous les champs.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await _authService.login(
        _emailController.text, _passwordController.text, null);

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      // ignore: use_build_context_synchronously
      context.push('/two-factor-verification', extra: {
        'email': _emailController.text,
        'password': _passwordController.text
      });
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, result['message']);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    final result = await ref.read(authProvider.notifier).signInWithGoogle();

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      context.go('/home'); // Ou toute autre route après la connexion réussie
    } else {
      showToast(context, result['message']);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail/ Numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                PasswordInputField(passwordController: _passwordController),
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
                  onPressed: isLoading ? null : _login,
                  textColor: AppTheme.backgroundColor,
                  isLoading: isLoading,
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
                  onPressed: isLoading ? null : _signInWithGoogle,
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
          const AuthScreenBottomCgu(),
        ],
      ),
    );
  }
}
