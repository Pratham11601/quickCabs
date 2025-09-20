import 'package:QuickCab/Screens/profile_module/model/profile_details_model.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_manager.dart';
import '../../../notificaton/notifications_services.dart';
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

  var userDetails = Rxn<Vendor>(); // vendor model from response
  var isLoading = false.obs;

  RxBool isNotificationSound = true.obs;

  /// Change language
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    // Optional: persist in storage
    GetStorage().write("selectedLanguage", lang);
  }

  Future<void> loadNotificationPreference() async {
    isNotificationEnabled.value =
        await NotificationService.areNotificationsEnabled();
  }

  Future<void> toggleNotifications(bool value) async {
    isNotificationEnabled.value = value;
    await NotificationService.setNotificationEnabled(value);
  }

  /// Logout function
  void logout() async {
    try {
      // 1. Clear persistent storage
      await LocalStorage.erase();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      debugPrint("Prefs after clear: ${prefs.getKeys()}"); // debug

      // 2. Clear APIManager token header
      APIManager().clearAuthorizationHeader();

      // 3. Cancel any ongoing API requests
      APIManager().cancelRequests();

      // 4. Delete all controllers
      Get.deleteAll(force: true);

      // 5. Show snackbar first
      ShowSnackBar.success(
        title: "Logout",
        message: "You have been logged out successfully!",
      );

      // 6. Then navigate
      Future.delayed(Duration(milliseconds: 300), () {
        Get.offAllNamed(Routes.LOGIN_SCREEN);
      });
    } catch (e) {
      debugPrint("Logout error: $e");
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
