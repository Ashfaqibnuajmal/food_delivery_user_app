import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Step 1 — Ask permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('✅ Notification permission granted');
    } else {
      log('❌ Notification permission denied');
    }

    // Step 2 — Setup local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    // ✅ FIXED — settings: as named parameter
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    // Step 3 — Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('📩 Foreground message received!');
      showLocalNotification(message);
    });
  }

  // ✅ Show local notification
  static Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: 0,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      notificationDetails: notificationDetails,
    );
  }

  // ✅ Save FCM token to Firestore
  static Future<void> saveTokenToFirestore(String userId) async {
    String? token = await _messaging.getToken();

    if (token != null) {
      await FirebaseFirestore.instance
          .collection('Users') // 👈 capital U — matches your Firestore
          .doc(userId)
          .update({
            'fcmToken': token,
            'tokenUpdatedAt': FieldValue.serverTimestamp(),
          });

      log('✅ FCM Token saved: $token');
    }
  }
}
