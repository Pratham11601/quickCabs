import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:own_idea/Screens/profile_module/model/profile_details_model.dart';
import 'package:own_idea/Screens/profile_module/profile_repository.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_manager.dart';
import '../../../routes/routes.dart';

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
    Get.offAllNamed(Routes.LOGIN_SCREEN);
    // Add your API / Auth logout logic here
    Get.snackbar(
      "Logout", "You have been logged out successfully!",
      snackPosition: SnackPosition.TOP,
      backgroundColor:
          ColorsForApp.colorVerifyGreen, // you can control transparency
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

  Future<bool> getProfileDetails() async {
    try {
      ProfileDetailsModel model =
          await profileRepository.getProfileDetailsApiCall();
      if (model.status == true) {
        userDeatils.value = model.vendor!;
        return true; 
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
