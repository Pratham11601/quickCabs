import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/profile_module/ui/subscription_screen.dart';
import 'package:own_idea/utils/app_colors.dart';

import '../../../routes/routes.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';
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
                  name: controller.userDeatils.value.fullname ?? "unknown",
                  phone: controller.userDeatils.value.phone ?? "-",
                  email: controller.userDeatils.value.email ?? "-",
                )),

            /// Account Section
            SettingsCard(
              sectionTitle: "Account",
              items: [
                SettingItem(
                  icon: Icons.description_outlined,
                  title: "documents".tr,
                  label: "Incomplete",
                  onTap: () {
                    Get.toNamed(Routes.MY_DOCUMENTS);
                  },
                ),
                SettingItem(
                  icon: Icons.notifications_outlined,
                  title: "notifications".tr,
                  toggleValue: controller.isNotificationEnabled,
                  hasSwitch: true,
                  switchValue: true,
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
                SettingItem(
                  icon: Icons.monetization_on_outlined,
                  title: "Subscription",
                  onTap: () => Get.toNamed(Routes.SUBSCRIPTION)
                ),
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
                SettingItem(
                  icon: Icons.location_on_outlined,
                  title: "state_support".tr,
                  onTap: () {},
                ),
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
                                Get.updateLocale(Locale('en', 'US')); // Switch to Hindi
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
                                Get.updateLocale(Locale('hi', 'IN')); // Switch to Hindi
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
                                Get.updateLocale(Locale('kn', 'IN'));  // Kannada locale code
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
            LogoutButton(onLogout: controller.logout),

            /// Footer
            const SizedBox(height: 20),
            Center(
              child: Text(
                  "app_version_info".tr,
                  textAlign: TextAlign.center,
                  style: TextHelper.size18.copyWith(
                      color: ColorsForApp.subTitleColor,
                      fontFamily: semiBoldFont)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
