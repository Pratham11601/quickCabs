import 'dart:io';

import 'package:QuickCab/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../api/api_manager.dart';
import '../../../routes/routes.dart';
import '../../../utils/config.dart';
import '../../../utils/storage_config.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/app_version.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/snackbar.dart';
import '../controller/profile_controller.dart';
import '../profile_widgets/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile Info Card
            Obx(() => ProfileInfoCard(
                  name: controller.userDetails.value?.fullname ?? "Unknown",
                  phone: controller.userDetails.value?.phone ?? "-",
                  email: controller.userDetails.value?.email ?? "-",
                  profileImage: (controller.userDetails.value?.profileImgUrl !=
                              null &&
                          controller
                              .userDetails.value!.profileImgUrl!.isNotEmpty)
                      ? "${Config.baseUrl}${controller.userDetails.value!.profileImgUrl}"
                      : "",
                )),

            /// Account Section
            SettingsCard(
              sectionTitle: "Account",
              items: [
                SettingItem(
                  icon: Icons.description_outlined,
                  title: "documents".tr,
                  onTap: () {
                    Get.toNamed(Routes.MY_DOCUMENTS);
                  },
                ),
                SettingItem(
                  icon: Icons.notifications_outlined,
                  title: "notifications".tr,
                  hasSwitch: true,
                  switchValue: Config.isNotificationSound.value,
                  toggleValue: Config.isNotificationEnabled,
                  onToggle: (val) async {
                    await controller.toggleNotifications(val);
                    print("✅ Notifications toggled to $val");
                  },
                ),
                SettingItem(
                  icon: Icons.security_outlined,
                  title: "privacy_security".tr,
                  onTap: () async {
                    // For Privacy Policy
                    await UrlLauncherHelper.openUrl(
                        "https://quickcabpune.com/privacy-policy.html");
                  },
                ),
                //For now as per client requirement it is hide, later on it will be uncomment
                //SettingItem(icon: FontAwesomeIcons.chessKing, title: "subscription_pro".tr, onTap: () => Get.toNamed(Routes.SUBSCRIPTION)),
              ],
            ),

            /// Support Section (REUSABLE)
            SettingsCard(
              sectionTitle: "support".tr,
              items: <SettingItem>[
                SettingItem(
                  icon: Icons.help_outline,
                  title: "help_support".tr,
                  onTap: () {
                    Get.toNamed(Routes.HELP_PAGE);
                  },
                ),
                // SettingItem(
                //   icon: Icons.location_on_outlined,
                //   title: "state_support".tr,
                //   onTap: () {},
                // ),
                SettingItem(
                  icon: Icons.language,
                  title: "language".tr,
                  isLanguage: true,
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("choose_language".tr,
                                style: TextHelper.h5.copyWith(
                                    fontFamily: semiBoldFont,
                                    color: ColorsForApp.blackColor)),
                            const SizedBox(height: 16),
                            ListTile(
                              title: Text("English",
                                  style: TextHelper.size19.copyWith(
                                      fontFamily: semiBoldFont,
                                      color: ColorsForApp.blackColor)),
                              onTap: () {
                                controller.changeLanguage("English");
                                Get.updateLocale(
                                    Locale('en', 'US')); // Switch to Hindi
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("हिंदी",
                                  style: TextHelper.size19.copyWith(
                                      fontFamily: semiBoldFont,
                                      color: ColorsForApp.blackColor)),
                              onTap: () {
                                controller.changeLanguage("हिंदी");
                                Get.updateLocale(
                                    Locale('hi', 'IN')); // Switch to Hindi
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("मराठी",
                                  style: TextHelper.size19.copyWith(
                                      fontFamily: semiBoldFont,
                                      color: ColorsForApp.blackColor)),
                              onTap: () {
                                controller.changeLanguage("मराठी");
                                Get.updateLocale(Locale('mr', 'IN'));
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text(
                                "ಕನ್ನಡ",
                                style: TextHelper.size19.copyWith(
                                  fontFamily: semiBoldFont,
                                  color: ColorsForApp.blackColor,
                                ),
                              ),
                              onTap: () {
                                controller.changeLanguage("ಕನ್ನಡ");
                                Get.updateLocale(
                                    Locale('kn', 'IN')); // Kannada locale code
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            /// Logout Button
            LogoutButton(onLogout: () {
              showLogoutDialog(context);
            }),

            /// Footer
            const SizedBox(height: 20),
            Center(
              child: FutureBuilder<String>(
                future: getAppVersionText(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      textAlign: TextAlign.center,
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.subTitleColor,
                        fontFamily: semiBoldFont,
                      ),
                    );
                  } else {
                    // fallback
                    return Text(
                      "Quick Cabs Driver\nMade with ❤️",
                      textAlign: TextAlign.center,
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.subTitleColor,
                        fontFamily: semiBoldFont,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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

  showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Logout',
            style: TextHelper.h7
                .copyWith(fontFamily: boldFont, color: ColorsForApp.blackColor),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextHelper.size19.copyWith(
                color: ColorsForApp.blackColor, fontFamily: regularFont),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  splashColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
                  highlightColor:
                      ColorsForApp.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Cancel',
                    style: TextHelper.size19.copyWith(
                      fontFamily: regularFont,
                      color: ColorsForApp.blackColor,
                    ),
                  ),
                ),
                width(4.w),
                InkWell(
                  onTap: () async {
                    logout();
                  },
                  splashColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
                  highlightColor:
                      ColorsForApp.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Confirm',
                    style: TextHelper.size19.copyWith(
                      fontFamily: regularFont,
                      color: ColorsForApp.primaryDarkColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
