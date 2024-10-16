import 'dart:convert';
import 'package:afrik_flow/providers/api_client_provider.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:afrik_flow/services/common_api_service.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiService _apiService = ApiService();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> init(WidgetRef ref, BuildContext context) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      await sendTokenToServer(token, ref);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
            ),
          ),
          payload: jsonEncode(message.data),
        );

        await ref.read(userProvider.notifier).refreshUserData(ref);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.data}');
      _handleNotificationClick(message.data, ref, context);
    });
  }

  Future<void> sendTokenToServer(String token, WidgetRef ref) async {
    final apiClient = ref.read(apiClientProvider);
    final url = Uri.parse('$apiBaseUrl/fcm/update-profile');

    await apiClient.post(
      url,
      body: jsonEncode({'device_id': token}),
    );
  }

  void _handleNotificationClick(
      Map<String, dynamic> data, WidgetRef ref, BuildContext context) {
    String? type = data['type'];
    if (type != null) {
      if (data['id'] != null) {
        _apiService.markNotificationAsRead(data['id'], ref);
      }
      redirectToScreen(type, data['data'], ref, context);
    }
  }

  void redirectToScreen(
      String type, dynamic data, WidgetRef ref, BuildContext context) {
    switch (type) {
      case 'Transaction':
        context.push('/transaction-details');
        break;
      case 'WelcomeMessage':
        context.push('/send');
        break;
      case 'KYC':
        context.push('/kyc');
        break;
      default:
        context.go('/home');
        break;
    }
  }
}
