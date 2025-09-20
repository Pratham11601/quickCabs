import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateController extends GetxController {
  var updateInfo = Rx<AppUpdateInfo?>(null);

  @override
  void onInit() {
    super.onInit();
    checkForUpdates(); // 🔥 auto check when app starts
  }

  Future<void> checkForUpdates() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        updateInfo.value = info;
        startImmediateUpdate();
      }
    } catch (e) {
      debugPrint("Error checking for updates: $e");
    }
  }

  Future<void> startImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      print("Error performing update: $e");
    }
  }
}
