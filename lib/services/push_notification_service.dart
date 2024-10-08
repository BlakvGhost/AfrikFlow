import 'package:afrik_flow/providers/api_client_provider.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init(WidgetRef ref) async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      await sendTokenToServer(token, ref);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu : ${message.notification?.title}');
    });
  }

  Future<void> sendTokenToServer(String token, WidgetRef ref) async {
    final apiClient = ref.read(apiClientProvider);
    final url = Uri.parse('$apiBaseUrl/fcm/update-profile');

    await apiClient.post(
      url,
      body: {'device_id': token},
    );
  }
}
