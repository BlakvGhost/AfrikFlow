import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/app_logo.dart';
import 'package:afrik_flow/widgets/input/password_input_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:afrik_flow/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  final String email;

  final String otp;

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

  Future<void> _resetPassword() async {
    if (_passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty) {
      showToast(context, "Veuillez entrer un nouveau mot de passe.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showToast(context, "Les mots de passe ne correspondent pas.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await _authService.resetPassword(widget.email, widget.otp,
        _passwordController.text, _confirmPasswordController.text);

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      showSucessToast(context, result['data']['data']);
      context.go('/login');
    } else {
      showToast(context, result['message'], isList: true);
    }
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
                    'Nouveau mot de passe !',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Veuillez entrer un nouveau mot de passe pour terminer le processus',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 25),
                PasswordInputField(passwordController: _passwordController),
                const SizedBox(height: 15),
                PasswordInputField(
                  passwordController: _confirmPasswordController,
                  label: "Confirmer mot de passe",
                ),
                const SizedBox(height: 25),
                CustomElevatedButton(
                  label: 'Réinitialiser',
                  onPressed: isLoading ? null : _resetPassword,
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
