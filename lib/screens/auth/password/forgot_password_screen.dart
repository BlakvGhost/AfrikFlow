import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:afrik_flow/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
    super.initState();
  }

  Future<void> _checkSession() async {
    final user = ref.read(userProvider);
    if (user?.token != null) {
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> _sendResetLink() async {
    if (_emailController.text.isEmpty) {
      showToast(context, "Veuillez entrer votre e-mail/numéro de téléphone.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result =
        await _authService.sendPasswordResetEmail(_emailController.text);

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      context.push('/confirm-otp', extra: result['data']['data']['to']);
    } else {
      showToast(context, result['message']);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              padding: const EdgeInsets.only(top: 80),
              children: [
                const AppLogo(),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Réinitialiser votre mot de passe!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
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
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomElevatedButton(
                  label: 'Envoyer le code',
                  onPressed: isLoading ? null : _sendResetLink,
                  textColor: AppTheme.backgroundColor,
                  isLoading: isLoading,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
