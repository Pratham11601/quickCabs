import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../api/api_manager.dart';
import '../utils/connection.dart';
import '../utils/jwt_config.dart';
import '../widgets/dialog.dart';
import '../utils/notifications.dart';

class AppController extends GetxController {
  final Connection connection = Connection();
  // final Notification notification = Notification();
  StreamSubscription<bool>? connectionSubscription;
  StreamSubscription<String>? notificationTokenSubscription;
  String? userToken;

  @override
  void onInit() async {
    super.onInit();

    // Fetch token
    userToken = await JwtConfig.fetchLocalUserToken();

    // bool isExistingUser = await LocalStorage.fetchValue(StorageKey.token) ?? false;

    // Initialize network service
    await initializeConnectionServices();

    // Initiate notification
    // String? fcmToken = await notification.initNotificationService();

    debugPrint('Token ===========> ${userToken.toString()}');
    // debugPrint('FCM on Dashboard ===========> ${fcmToken.toString()}');

    // Initialize api manager
    APIManager.init(this);
  }

  @override
  void onClose() {
    connectionSubscription?.cancel();
    notificationTokenSubscription?.cancel();
    super.onClose();
  }

  void updateToken(String? token) {
    userToken = token;
    JwtConfig.storeUserToken(token);
  } 

  /// Notification
  Future<void> showNotificationAlertDialog() async {
    bool dialogResult = await Get.dialog<bool>(
          CustomDialog.yesNoDialog(
            Get.context!,
            title: 'Enable Notifications',
            note:
                'Stay updated with important alerts, updates, and offers. Would you like to enable notifications?',
          ),
        ) ??
        false;
    if (dialogResult) {}
  }

  /// Connection
  Future<void> initializeConnectionServices() async {
    connection.initValue = await Connection.checkInternet();
    connectionSubscription = connection.onChangeConnectivity.listen((event) {
      debugPrint('Has internet $event');
    });
  }
}
