import 'package:afrik_flow/utils/global_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, dynamic>> login(
    String identifier,
    String password,
    String? otpCode,
  ) async {
    final url = Uri.parse('$apiBaseUrl/auth/login');

    String? getLoginField(String identifier) {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

      if (emailRegex.hasMatch(identifier)) {
        return 'email';
      } else if (phoneRegex.hasMatch(identifier)) {
        return 'phone_num';
      }
      return null;
    }

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
      final errorMessage = jsonDecode(response.body)['data']['error'];
      // ignore: avoid_print
      print(jsonDecode(response.body));
      return {'success': false, 'message': errorMessage};
    }
  }
}
