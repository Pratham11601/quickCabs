import 'package:QuickCab/Screens/profile_module/model/profile_details_model.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_manager.dart';
import '../../../routes/routes.dart';
import '../../../utils/storage_config.dart';
import '../repository/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileRepository profileRepository = ProfileRepository(APIManager());

  /// Account Section
  var isNotificationEnabled = true.obs;
  var documentsStatus = "Incomplete".obs;

  /// Support Section
  var selectedLanguage = "English".obs;

  /// Toggle Notification
  void toggleNotifications(bool value) {
    isNotificationEnabled.value = value;
  }

  var userDetails = Rxn<Vendor>(); // vendor model from response
  var isLoading = false.obs;

  /// Change language
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    // Optional: persist in storage
    GetStorage().write("selectedLanguage", lang);
  }

  /// Logout function
  void logout() async {
    // 1. Clear persistent storage
    await LocalStorage.erase();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 2. Clear APIManager token header
    APIManager().clearAuthorizationHeader(); // <-- Use your APIManager

    // 3. Cancel any ongoing API requests (optional but safe)
    APIManager().cancelRequests();

    // 4. Delete all controllers (clear old state)
    Get.deleteAll(force: true);

    // 5. Navigate to login
    Get.offAllNamed(Routes.LOGIN_SCREEN);

    // 6. Show snackbar
    Get.snackbar(
      "Logout",
      "You have been logged out successfully!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: ColorsForApp.colorVerifyGreen,
      colorText: ColorsForApp.whiteColor,
    );
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
  }

  Rx<Vendor> userDeatils = Vendor().obs;

  Future<void> getProfileDetails() async {
    try {
      isLoading.value = true;
      ProfileDetailsModel model = await profileRepository.getProfileDetailsApiCall();

      if (model.status == true) {
        userDetails.value = model.vendor;
      } else {
        debugPrint("Error: ${model.vendor!.fullname!}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
