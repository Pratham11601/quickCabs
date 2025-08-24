import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/routes.dart';

class ProfileController extends GetxController {
  /// User Information
  var userName = "Rajesh Kumar".obs;
  var phoneNumber = "+91 9876543210".obs;
  var email = "rajesh.kumar@email.com".obs;

  /// Account Section
  var isNotificationEnabled = true.obs;
  var documentsStatus = "Incomplete".obs;

  /// Support Section
  var selectedLanguage = "English".obs;

  /// Toggle Notification
  void toggleNotifications(bool value) {
    isNotificationEnabled.value = value;
  }

  /// Change language
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    // Optional: persist in storage
    GetStorage().write("selectedLanguage", lang);
  }

  /// Logout function
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.toNamed(Routes.LOGIN_SCREEN);
    // Add your API / Auth logout logic here
    Get.snackbar(
      "Logout", "You have been logged out successfully!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: ColorsForApp.colorVerifyGreen, // you can control transparency
      colorText: ColorsForApp.whiteColor,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Load saved language if exists
    final savedLang = GetStorage().read("selectedLanguage");
    if (savedLang != null) {
      selectedLanguage.value = savedLang;
    }
  }
}
