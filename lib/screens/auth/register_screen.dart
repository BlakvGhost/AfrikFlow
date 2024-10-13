import 'package:afrik_flow/models/country.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/auth_service.dart';
import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/services/push_notification_service.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/app_logo.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:afrik_flow/widgets/input/password_input_field.dart';
import 'package:afrik_flow/widgets/ui/auth_screen_bottom_cgu.dart';
import 'package:afrik_flow/widgets/ui/ph_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/providers/auth_notifier.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends ConsumerState<RegisterScreen> {
  String? selectedCountry;
  CountriesResponse? countries;
  bool isLoading = true;
  bool isLoadingBtn = false;

  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
    super.initState();
    _loadCountries();
  }

  Future<void> _checkSession() async {
    final user = ref.read(userProvider);
    if (user?.token != null) {
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> _loadCountries() async {
    try {
      CountriesResponse fetchedCountries = await _apiService.fetchCountries();
      setState(() {
        countries = fetchedCountries;
        selectedCountry = fetchedCountries.currentCountry.id;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showToast(context, "Erreur lors du chargement des pays ");
    }
  }

  Future<void> _register() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        selectedCountry == null) {
      showToast(context, "Veuillez remplir tous les champs.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showToast(context, "Les mots de passe ne correspondent pas.");
      return;
    }

    if (!isValidEmail(_emailController.text)) {
      showToast(context, "Veuillez entrer un email valide.");
      return;
    }

    setState(() {
      isLoadingBtn = true;
    });

    final selectedCountryData = countries?.countries
        .firstWhere((country) => country.id == selectedCountry);

    final res = await _authService.register(
      _firstNameController.text,
      _lastNameController.text,
      _emailController.text,
      _phoneController.text,
      _passwordController.text,
      _confirmPasswordController.text,
      selectedCountryData,
    );

    if (res['success']) {
      // ignore: use_build_context_synchronously
      context.push('/email-verification', extra: _emailController.text);
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, res['message'], isList: true);
    }

    setState(() {
      isLoadingBtn = false;
    });
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoadingBtn = true;
    });

    final result = await ref.read(authProvider.notifier).signInWithGoogle();

    setState(() {
      isLoadingBtn = false;
    });

    if (result['success']) {
      await PushNotificationService().init(ref, context);
      context.go('/home');
    } else {
      showToast(context, result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                const AppLogo(),
                const SizedBox(height: 10),
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
                  ),
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  value: selectedCountry,
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez le pays',
                    border: OutlineInputBorder(),
                  ),
                  items: countries?.countries.map((country) {
                        return DropdownMenuItem<String>(
                          value: country.id,
                          child: Row(
                            children: [
                              Image.network(
                                country.flag,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text('${country.slug} (${country.countryCode})'),
                            ],
                          ),
                        );
                      }).toList() ??
                      [],
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 20),
                PasswordInputField(passwordController: _passwordController),
                const SizedBox(height: 20),
                PasswordInputField(
                  passwordController: _confirmPasswordController,
                  label: "Confirmer mot de passe",
                ),
                const SizedBox(height: 20),
                const AuthScreenBottomCgu(),
                CustomElevatedButton(
                  label: 'S\'inscrire',
                  onPressed: isLoadingBtn ? null : _register,
                  textColor: AppTheme.backgroundColor,
                  isLoading: isLoadingBtn,
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
                  onPressed: isLoadingBtn ? null : _signInWithGoogle,
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
