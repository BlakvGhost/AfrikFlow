import 'package:afrik_flow/models/country.dart';
import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/themes/app_theme.dart';
import 'package:afrik_flow/utils/helpers.dart';
import 'package:afrik_flow/widgets/btn/custom_elevated_button.dart';
import 'package:afrik_flow/widgets/input/password_input_field.dart';
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
  CountriesResponse? countries;
  bool isLoading = true;

  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      CountriesResponse fetchedCountries = await _apiService.fetchCountries();
      setState(() {
        countries = fetchedCountries;
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
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });

    context.push('/email-verification', extra: _emailController.text);
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
                              Text(country.code),
                              const SizedBox(width: 8),
                              Text('${country.slug} (${country.code})'),
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
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                PasswordInputField(passwordController: _passwordController),
                const SizedBox(height: 20),
                PasswordInputField(
                  passwordController: _confirmPasswordController,
                  label: "Confirmer mot de passe",
                ),
                const SizedBox(height: 30),
                CustomElevatedButton(
                  label: 'S\'inscrire',
                  onPressed: isLoading ? null : _register,
                  textColor: AppTheme.backgroundColor,
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
          const AuthScreenBottomCgu(),
        ],
      ),
    );
  }
}
