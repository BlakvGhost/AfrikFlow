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
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> init(WidgetRef ref, BuildContext context) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        await _handleNotificationClick(
            notificationResponse.payload!, ref, context);
      },
      // onDidReceiveBackgroundNotificationResponse: backgroundHandler,
    );

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
      print("Received");

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
      print("App opened from notification");
      if (message.data.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleNotificationClick(jsonEncode(message.data), ref, context);
        });
      }
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

  Future<void> _handleNotificationClick(
      String data, WidgetRef ref, BuildContext context) async {
    try {
      final decodedData = jsonDecode(data);
      final data0 = jsonDecode(decodedData['content']);

      String? type = data0['notificationType'];

      if (type != null) {
        if (data0['data']['id'] != null) {
          int notificationId = data0['data']['id'];
          ApiService().markNotificationAsRead(notificationId, ref);
        }
        redirectToScreen(type, data0['data'], ref, context);
      }
    } catch (e) {
      //
    }
  }

  void redirectToScreen(
      String type, dynamic data, WidgetRef ref, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (type) {
        case 'Transaction':
          context.push('/transaction-details', extra: data['transaction']);
          break;
        case 'WelcomeMessage':
          context.push('/send');
          break;
        case 'KYC':
          context.push('/kyc');
          break;
        case 'auth':
          context.push('/profile');
          break;
        default:
          context.go('/home');
          break;
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(
    NotificationResponse notificationResponse) async {}
