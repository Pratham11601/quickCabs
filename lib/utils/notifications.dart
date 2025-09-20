import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_enums.dart';
import 'permission_handler.dart';

class Notification {
  String? fcmToken;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android notification settings
  static final AndroidInitializationSettings _initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher.png');

  Future<String?> initNotificationService() async {
    fcmToken = await FirebaseMessaging.instance.getToken().onError((error, stackTrace) => null);
    debugPrint('FCM Token=======> $fcmToken');

    await _initializeLocalNotifications();
    return fcmToken;
  }

  Future<void> _initializeLocalNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<NotificationStatus> isNotificationEnabled([PermissionStatus? permissionStatus]) async {
    switch (permissionStatus ?? await PermissionHandler.getNotificationStatus()) {
      case PermissionStatus.granted:
        return NotificationStatus.granted;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.provisional:
      case PermissionStatus.limited:
        return NotificationStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return NotificationStatus.permanentlyDenied;
    }
  }

  Future<NotificationStatus> askNotificationPermission([PermissionStatus? permissionStatus]) async {
    PermissionStatus status = (permissionStatus ?? await PermissionHandler.isNotificationEnabled());
    switch (status) {
      case PermissionStatus.granted:
        return NotificationStatus.granted;
      case PermissionStatus.denied:
        PermissionStatus status = await PermissionHandler.askNotificationPermission();
        return isNotificationEnabled(status);
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        return await isNotificationEnabled();
      case PermissionStatus.restricted:
      case PermissionStatus.provisional:
      case PermissionStatus.limited:
        return NotificationStatus.denied;
    }
  }

  Stream<String> get onTokenRefresh => FirebaseMessaging.instance.onTokenRefresh.asyncMap((token) {
        fcmToken = token;
        return token;
      });

  static Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode, // Unique ID
      message.notification?.title ?? 'No title',
      message.notification?.body ?? 'No body',
      notificationDetails,
    );
  }
}
