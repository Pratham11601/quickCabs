import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
    static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static const String _notificationPrefKey = 'notifications_enabled';

  /// Call once in main() to load saved state
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled = prefs.getBool(_notificationPrefKey) ?? true;
    print(
        "🔔 Notifications are: ${notificationsEnabled ? "ENABLED" : "DISABLED"}");
          if (notificationsEnabled) {
      await subscribeToNotifications();
    } else {
      await unsubscribeFromNotifications();
    }
  }

  /// Toggle ON/OFF
  static Future<void> setNotificationEnabled(bool enable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPrefKey, enable);
    print(enable ? "🔔 Notifications ENABLED" : "🔕 Notifications DISABLED");

    if (enable) {
      await subscribeToNotifications();
    } else {
      await unsubscribeFromNotifications();
    }
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationPrefKey) ?? true;
  }
    // Subscribe to notifications
  static Future<void> subscribeToNotifications() async {
    await _firebaseMessaging.subscribeToTopic('all');
    await _firebaseMessaging.requestPermission();
  }

  // Unsubscribe from notifications
  static Future<void> unsubscribeFromNotifications() async {
    await _firebaseMessaging.unsubscribeFromTopic('all');
  }
}
