import 'package:afrik_flow/models/country.dart';
import 'package:afrik_flow/models/user.dart';
import 'package:afrik_flow/providers/api_client_provider.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:afrik_flow/services/firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();

  String? getLoginField(String identifier) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final phoneRegex = RegExp(
      r'^(?:\+?[0-9]{10,15}|[0-9]{8,10})$',
    );

    if (emailRegex.hasMatch(identifier)) {
      return 'email';
    } else if (phoneRegex.hasMatch(identifier)) {
      return 'phone_num';
    }
    return null;
  }

  Future<Map<String, dynamic>> login(
    String identifier,
    String password,
    String? otpCode,
  ) async {
    final url = Uri.parse('$apiBaseUrl/auth/login');

    final loginField = getLoginField(identifier);

    if (loginField == null) {
      return {
        'success': false,
        'message': 'Email ou numero de telephone invalide.'
      };
    }

    final loginData = {
      loginField: identifier,
      'password': password,
    };

    if (otpCode != null) {
      loginData['two_factor'] = otpCode;
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['data']?['error'] ??
          responseBody['message'] ??
          'Une erreur est survenue';
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> register(
      String firstName,
      String lastName,
      String email,
      String phone,
      String password,
      String passwordConfirmation,
      Country? country) async {
    final url = Uri.parse('$apiBaseUrl/auth/register');

    final registerData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'confirm_password': passwordConfirmation,
      'country_id': country?.id,
      'phone_num': "${country?.countryCode}$phone",
      'plateform': 'web'
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registerData),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final errorMessage = jsonDecode(response.body)['data'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> verifyEmail(String email, String otpCode) async {
    final url = Uri.parse('$apiBaseUrl/auth/verify-email');

    final registerData = {
      'email': email,
      'token': otpCode,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registerData),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> resendEmailCode(String email) async {
    final url = Uri.parse('$apiBaseUrl/auth/resend-email-token');

    final registerData = {
      'email': email,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registerData),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> sendPasswordResetEmail(String identifier) async {
    final url = Uri.parse('$apiBaseUrl/password/forgot');

    final loginField = getLoginField(identifier);

    if (loginField == null) {
      return {
        'success': false,
        'message': 'Email ou numero de telephone invalide.'
      };
    }

    final loginData = {
      loginField: identifier,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> verifyOtpCode(
      String email, String otpCode) async {
    final url = Uri.parse('$apiBaseUrl/password/verify-otp');

    final registerData = {
      'email': email,
      'otp': otpCode,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registerData),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> getSelfData(WidgetRef ref) async {
    final apiClient = ref.read(apiClientProvider);
    final url = Uri.parse('$apiBaseUrl/user/me');

    final response = await apiClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('data')) {
        final user = User.fromJson(jsonResponse['data']);
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'message': 'Données utilisateur manquantes.'};
      }
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    final userCredential = await _firebaseService.signInWithGoogle();
    if (userCredential != null) {
      final url = Uri.parse('$apiBaseUrl/auth/login-with-google');

      final googleUser = userCredential.user;
      if (googleUser != null) {
        final userData = {
          'email': googleUser.email,
          'first_name': googleUser.displayName?.split(' ').first ?? '',
          'last_name': googleUser.displayName?.split(' ').last ?? '',
          'googleId': googleUser.uid,
          'avatar': googleUser.photoURL,
        };

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return {'success': true, 'data': responseData};
        } else {
          final errorMessage = jsonDecode(response.body)['message'];
          return {'success': false, 'message': errorMessage};
        }
      }
    }
    return {'success': false, 'message': 'Échec de la connexion Google'};
  }
}
