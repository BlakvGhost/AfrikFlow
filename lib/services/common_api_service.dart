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

  Future<Map<String, dynamic>> uploadImage(
      File image, File selfieImage, WidgetRef ref) async {
    final user = ref.read(userProvider);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/user/upload-legal-doc'),
    );
    request.headers['Authorization'] = 'Bearer ${user?.token}';

    request.files
        .add(await http.MultipartFile.fromPath('legal_doc', image.path));
    request.files.add(
        await http.MultipartFile.fromPath('selfie_image', selfieImage.path));

    var response = await request.send();

    final responseBody = await response.stream.bytesToString();

    final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      await ref.read(userProvider.notifier).refreshUserData(ref);
      return {'success': true, 'data': jsonResponse['data']};
    } else {
      return {'success': false, 'message': jsonResponse['message']};
    }
  }

  Future<Map<String, dynamic>> resubmitLegalDocuments(
      File? image, File? selfieImage, String kycId, WidgetRef ref) async {
    final user = ref.read(userProvider);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/user/upload-legal-doc/$kycId'),
    );
    request.headers['Authorization'] = 'Bearer ${user?.token}';

    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('legal_doc', image.path));
    }
    if (selfieImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('selfie_image', selfieImage.path));
    }

    var response = await request.send();

    final responseBody = await response.stream.bytesToString();

    final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      await ref.read(userProvider.notifier).refreshUserData(ref);
      return {'success': true, 'data': jsonResponse['data']};
    } else {
      return {'success': false, 'message': jsonResponse['message']};
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      String? firstName, String? lastName, String? phoneNumber,
      {bool? isTwoFactorEnabled,
      bool? isAcceptedNotifications,
      File? avatar,
      required WidgetRef ref}) async {
    final user = ref.read(userProvider);

    final url = Uri.parse('$apiBaseUrl/user/update-profile');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer ${user?.token}';

    if (firstName != null && firstName.isNotEmpty) {
      request.fields['first_name'] = firstName;
    }

    if (lastName != null && lastName.isNotEmpty) {
      request.fields['last_name'] = lastName;
    }

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      request.fields['phone_number'] = phoneNumber;
    }

    if (isTwoFactorEnabled != null) {
      request.fields['isTwoFactorEnabled'] = isTwoFactorEnabled.toString();
    }

    if (isAcceptedNotifications != null) {
      request.fields['isAcceptedNotifications'] =
          isAcceptedNotifications.toString();
    }

    if (avatar != null) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      await ref.read(userProvider.notifier).refreshUserData(ref);
      return {'success': true, 'message': jsonDecode(responseBody)['message']};
    } else {
      final errorMessage = jsonDecode(responseBody)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> updateUserPassword(String currentPassword,
      String newPassword, String confirmNewPassword, WidgetRef ref) async {
    final ApiClient apiClient = ref.read(apiClientProvider);

    final url = Uri.parse('$apiBaseUrl/user/update-password');
    final response = await apiClient.post(url,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmNewPassword,
        }));

    if (response.statusCode == 200) {
      return {'success': true, 'message': jsonDecode(response.body)['message']};
    } else {
      final errorMessage = jsonDecode(response.body)['data'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> deleteAccount(WidgetRef ref) async {
    final ApiClient apiClient = ref.read(apiClientProvider);

    final url = Uri.parse('$apiBaseUrl/user/delete-account');
    final response = await apiClient.delete(url);

    if (response.statusCode == 200) {
      return {'success': true, 'message': jsonDecode(response.body)['message']};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }
}
