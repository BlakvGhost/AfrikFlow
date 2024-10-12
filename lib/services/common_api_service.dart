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
    late final ApiClient apiClient = ref.read(apiClientProvider);

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
    late final ApiClient apiClient = ref.read(apiClientProvider);

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
}
