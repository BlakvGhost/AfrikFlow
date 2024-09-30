import 'dart:convert';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$apiBaseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }
}
