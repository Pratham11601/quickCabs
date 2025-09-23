import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'notification_helper.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/cloud-platform"
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": dotenv.env['PROJECT_ID'],
        "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
        "private_key": dotenv.env['PRIVATE_KEY']!.replaceAll(r'\n', '\n'),
        "client_email": dotenv.env['CLIENT_EMAIL'],
        "client_id": "109306028107785227851",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40quick-cabs-d3951.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );

    final accessServerKey = client.credentials.accessToken.data;
    print("server token is : $accessServerKey");
    return accessServerKey;
  }
}

class FirebaseNotification {
  static Future<void> initialize() async {
    // Get the FCM token
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log("FCM Token: $fcmToken");

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Message Received: ${message.notification?.title}");

      // Use GetX to show a dialog or a snackbar
      if (message.notification != null) {
        // Prepare notification details
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'new_lead_channel',
          'your channel name',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
        );

        NotificationDetails platformChannelSpecifics =
            const NotificationDetails(android: androidPlatformChannelSpecifics);

        flutterLocalNotificationsPlugin.show(
          0, // Notification ID
          message.notification!.title ?? "Notification",
          message.notification!.body ?? "You have a new message.",
          platformChannelSpecifics,
        );
      }
    });

    // Handle messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Message opened from notification: ${message.notification?.title}");

      if (message.notification != null) {
        // Prepare notification details
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'new_lead_channel',
          'New Lead Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
        );
        NotificationDetails platformChannelSpecifics =
            const NotificationDetails(android: androidPlatformChannelSpecifics);

        flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title ?? "You have Recieved New Lead",
          message.notification!.body ?? "Please check.",
          platformChannelSpecifics,
        );
      }
    });
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    log("Background Message Received: ${message.notification?.title}");

    // Use GetX to show a dialog or a snackbar
    if (message.notification != null) {
      // Prepare notification details
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'new_lead_channel',
        'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
      );

      NotificationDetails platformChannelSpecifics =
          const NotificationDetails(android: androidPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        message.notification!.title ?? "Notification",
        message.notification!.body ?? "You have a new message.",
        platformChannelSpecifics,
      );
    }
  }
}
