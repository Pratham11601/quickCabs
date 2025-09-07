import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuickCab/utils/app_colors.dart';

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
                  title: "Documents",
                  label: "Incomplete",
                  onTap: () {
                    Get.toNamed(Routes.MY_DOCUMENTS);
                  },
                ),
                SettingItem(
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  toggleValue: controller.isNotificationEnabled,
                  hasSwitch: true,
                  switchValue: true,
                ),
                SettingItem(
                  icon: Icons.security_outlined,
                  title: "Privacy & Security",
                  onTap: () async {
                    // For Privacy Policy
                    await UrlLauncherHelper.openUrl(
                        "https://quickcabpune.com/privacy-policy.html");
                  },
                ),
              ],
            ),

            /// Support Section (REUSABLE)
            SettingsCard(
              sectionTitle: "Support",
              items: <SettingItem>[
                SettingItem(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () {
                    Get.toNamed(Routes.HELP_PAGE);
                  },
                ),
                SettingItem(
                  icon: Icons.location_on_outlined,
                  title: "State wise support",
                  onTap: () {},
                ),
                SettingItem(
                  icon: Icons.language,
                  title: "Language",
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
                            Text("Choose Language",
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
                  "Quick Cabs Driver v2.1.0\nMade with ❤️ for professional drivers",
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
