import 'package:afrik_flow/models/user.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(false);

  Future<Map<String, dynamic>> login(
      String identifier, String password, String? otpCode) async {
    state = true;

    final authService = _ref.read(authServiceProvider);

    final result = await authService.login(identifier, password, otpCode);

    state = false;

    if (result['success']) {
      final user = User.fromJson(result['data']['data']);
      _ref.read(userProvider.notifier).setUser(user);
    }

    return result;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});
