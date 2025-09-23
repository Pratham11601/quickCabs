import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../api/api_manager.dart';
import '../main.dart';
import '../models/common_model.dart';
import '../repository/app_repo.dart';
import '../utils/app_enums.dart';
import '../utils/connection.dart';
import '../utils/jwt_config.dart';
import '../widgets/dialog.dart';
import '../utils/notifications.dart' as n;

class AppController extends GetxController {
  final Connection connection = Connection();
  final n.Notification notification = n.Notification();
  StreamSubscription<bool>? connectionSubscription;
  StreamSubscription<String>? notificationTokenSubscription;
  String? userToken;
  String? fcmToken;

  @override
  void onInit() async {
    super.onInit();

    // Fetch token
    userToken = await JwtConfig.fetchLocalUserToken();

    // bool isExistingUser = await LocalStorage.fetchValue(StorageKey.token) ?? false;

    // Initialize network service
    await initializeConnectionServices();

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

  Future<void> initializeNotificationServices() async {
    NotificationStatus notificationStatus =
        await notification.isNotificationEnabled();
    if (notificationStatus == NotificationStatus.granted) {
      String? fcmToken = await notification.initNotificationService();
      if (userToken != null) {
        updateFcmToken(fcmToken!);
      }
      notificationTokenSubscription?.cancel();
      notificationTokenSubscription =
          notification.onTokenRefresh.listen(updateFcmToken);
      // FirebaseMessaging.onMessage.listen(handleFirebaseNotification);
      // FirebaseMessaging.onBackgroundMessage(handleFirebaseBackgroundNotification);
    } else {
      NotificationStatus status =
          await askNotificationPermission(notificationStatus);
      if (status == NotificationStatus.granted) {
        await initializeNotificationServices();
      } else {
        await showNotificationAlertDialog();
      }
    }
  }

  Future<RefreshFcmModel?> updateFcmToken(String fcmToken) async {
    try {
      if (userToken != null) {
        RefreshFcmModel updateFcmModel =
            await AppRepository.refreshFCMToken(params: {'newToken': fcmToken});
        debugPrint('fcmToken send to Backend is  ==>>>>>>>>>>> $fcmToken');

        if (updateFcmModel.status == 1) {
          return updateFcmModel;
        }
      }
    } catch (e) {
      debugPrint('Error in RefreshFcmModel: ${e.toString()}');
    }
    return null;
  }

  Future<NotificationStatus> askNotificationPermission(
      [NotificationStatus? status]) async {
    switch (status ?? await notification.isNotificationEnabled()) {
      case NotificationStatus.granted:
        return NotificationStatus.granted;
      case NotificationStatus.denied:
        NotificationStatus status =
            await notification.askNotificationPermission();
        if (status == NotificationStatus.granted) {
          return status;
        } else {
          await showNotificationAlertDialog();
          return notification.isNotificationEnabled();
        }
      case NotificationStatus.permanentlyDenied:
        await showNotificationAlertDialog();
        return notification.isNotificationEnabled();
    }
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
