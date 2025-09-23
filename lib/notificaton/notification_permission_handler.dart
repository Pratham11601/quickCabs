import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionHelper {
  /// Returns true if permission granted, false otherwise
  static Future<bool> requestNotificationPermission() async {
    if (GetPlatform.isAndroid) {
      final notifStatus = await Permission.notification.request();

      if (notifStatus.isGranted) {
        log("✅ Notifications granted (Android)");
        return true;
      } else if (notifStatus.isDenied) {
        log("❌ Notifications denied (Android)");
        return false;
      } else if (notifStatus.isPermanentlyDenied) {
        log("⚠️ Notifications permanently denied → Opening settings");
        await openAppSettings();
        return false;
      }
    } else if (GetPlatform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log("✅ Notifications granted (iOS)");
        return true;
      } else {
        log("❌ Notifications denied (iOS)");
        return false;
      }
    } else {
      log("ℹ️ Unsupported platform for notifications.");
      return false; // ✅ fallback
    }

    // fallback just in case
    return false;
  }
}
