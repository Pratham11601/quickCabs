import 'dart:developer';

import 'package:QuickCab/Screens/profile_module/model/profile_details_model.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_manager.dart';
import '../../../notificaton/notification_permission_handler.dart';
import '../../../notificaton/notifications_services.dart';
import '../../../routes/routes.dart';
import '../../../utils/config.dart';
import '../../../utils/storage_config.dart';
import '../repository/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileRepository profileRepository = ProfileRepository(APIManager());

  /// Account Section
  var documentsStatus = "Incomplete".obs;

  /// Support Section
  var selectedLanguage = "English".obs;

  var userDetails = Rxn<Vendor>(); // vendor model from response
  var isLoading = false.obs;

  /// Change language
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    // Optional: persist in storage
    GetStorage().write("selectedLanguage", lang);
  }

  Future<void> loadNotificationPreference() async {
    Config.isNotificationEnabled.value =
        await NotificationService.areNotificationsEnabled();
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      bool granted = false;

      if (GetPlatform.isAndroid) {
        final status = await Permission.notification.status;

        if (status.isGranted) {
          granted = true;
        } else if (status.isDenied) {
          final result = await Permission.notification.request();
          granted = result.isGranted;
        } else if (status.isPermanentlyDenied) {
          // Open settings
          await openAppSettings();
          granted = false;
        }
      } else if (GetPlatform.isIOS) {
        final settings =
            await FirebaseMessaging.instance.getNotificationSettings();

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          granted = true;
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.notDetermined) {
          final newSettings =
              await FirebaseMessaging.instance.requestPermission();
          granted =
              newSettings.authorizationStatus == AuthorizationStatus.authorized;
        } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
          // Show dialog to open settings
          Get.snackbar("Permission Denied",
              "Please enable notifications from Settings.");
          granted = false;
        }
      }

      // Update notification service and config
      await NotificationService.setNotificationEnabled(granted);
      Config.isNotificationEnabled.value = granted;
      log(granted ? "✅ Notifications enabled" : "❌ Notifications OFF");
    } else {
      // Turn OFF directly
      await NotificationService.setNotificationEnabled(false);
      Config.isNotificationEnabled.value = false;
      log("🔕 Notifications disabled by user");
    }
  }


  @override
  void onInit() {
    super.onInit();
    // Load saved language if exists
    getProfileDetails();
    final savedLang = GetStorage().read("selectedLanguage");
    if (savedLang != null) {
      selectedLanguage.value = savedLang;
    }
    loadNotificationPreference();
  }

  Future<void> getProfileDetails() async {
    try {
      isLoading.value = true;
      ProfileDetailsModel model =
          await profileRepository.getProfileDetailsApiCall();

      if (model.status == true && model.vendor != null) {
        userDetails.value = model.vendor; // ✅ assign to the reactive variable
        debugPrint("User fullname: ${model.vendor!.fullname}");
      } else {
        debugPrint("Error fetching profile details");
      }
    } catch (e) {
      debugPrint("Error in getProfileDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
