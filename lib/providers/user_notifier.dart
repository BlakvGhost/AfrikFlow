import 'package:afrik_flow/models/user.dart';
import 'package:afrik_flow/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    loadUserData();
  }

  final _authService = AuthService();

  void setUser(User user) {
    state = user;
    _storeUserData(user);
  }

  Future<void> refreshUserData() async {
    final result = await _authService.getSelfData();
    print(result);
    if (result['success']) {
      final User newUserData = result['user'];
      setUser(newUserData);
    } else {}
  }

  Future<void> _storeUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      state = User.fromJson(userData);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
