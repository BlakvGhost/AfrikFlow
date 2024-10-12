import 'dart:io';

import 'package:afrik_flow/models/country.dart';
import 'package:afrik_flow/providers/api_client_provider.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/api_client.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<CountriesResponse> fetchCountries() async {
    final url = Uri.parse('$apiBaseUrl/countries');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final countriesData = jsonResponse['data'];

      return CountriesResponse.fromJson(countriesData);
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<Map<String, dynamic>> markNotificationAsRead(
      int id, WidgetRef ref) async {
    final ApiClient apiClient = ref.read(apiClientProvider);

    final url = Uri.parse('$apiBaseUrl/notifications/mark-as-read/$id');
    final response = await apiClient.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      await ref.read(userProvider.notifier).refreshUserData(ref);
      return {'success': true, 'data': jsonResponse['data']};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> markNotificationsAsRead(WidgetRef ref) async {
    final ApiClient apiClient = ref.read(apiClientProvider);

    final url = Uri.parse('$apiBaseUrl/notifications/mark-all-as-read');
    final response = await apiClient.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      await ref.read(userProvider.notifier).refreshUserData(ref);
      return {'success': true, 'data': jsonResponse['data']};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> uploadImage(File image, WidgetRef ref) async {
    final user = ref.read(userProvider);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/user/upload-legal-doc'),
    );
    request.headers['Authorization'] = 'Bearer ${user?.token}';

    request.files
        .add(await http.MultipartFile.fromPath('legal_doc', image.path));

    var response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      await ref.read(userProvider.notifier).refreshUserData(ref);
      return {'success': true, 'data': jsonResponse['data']};
    } else {
      final errorMessage = jsonDecode(responseBody)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }
}
