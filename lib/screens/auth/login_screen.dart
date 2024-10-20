import 'package:afrik_flow/models/user.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/app_logo.dart';
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
      if (!mounted) return;

      if (result['data']['data'] is Map &&
          result['data']?['data']?['token'] != null) {
        final user = User.fromJson(result['data']['data']);
        ref.read(userProvider.notifier).setUser(user);
        context.go('/home');
      } else {
        context.push('/two-factor-verification', extra: {
          'email': result['data']['data']['to'],
          'password': _passwordController.text
        });
      }
    } else {
      if (mounted) {
        showToast(context, result['message']);
      }
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
      // await PushNotificationService().init(ref, context);
      context.go('/home');
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
              padding: const EdgeInsets.only(top: 60),
              children: [
                const AppLogo(),
                const SizedBox(height: 10),
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
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 25),
                PasswordInputField(passwordController: _passwordController),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push('/forgot-password');
                    },
                    child: const Text('Mot de passe oublié?'),
                  ),
                ),
                const AuthScreenBottomCgu(),
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
        ],
      ),
    );
  }
}
