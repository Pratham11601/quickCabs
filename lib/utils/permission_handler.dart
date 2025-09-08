import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  PermissionHandler._();

  /// Camera
  static Future<bool> getCameraStatus() async {
    return await Permission.camera.isGranted;
  }


  /// Notification
  // Notification enabled
  static Future<PermissionStatus> isNotificationEnabled() async {
    PermissionStatus status = await getNotificationStatus();
    return status;
  }

  // Notification status
  static Future<PermissionStatus> getNotificationStatus() async {
    return await Permission.notification.status;
  }

  // Notification status
  static Future<PermissionStatus> askNotificationPermission() async {
    return await Permission.notification.request();
  }
}