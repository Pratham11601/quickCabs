import 'package:QuickCab/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/routes.dart';
import '../../../utils/config.dart';
import '../../../utils/storage_config.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/app_version.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/snackbar.dart';
import '../../landing_page/controller/dashboard_controller.dart';
import '../controller/profile_controller.dart';
import '../profile_widgets/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.find();
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Obx(() {
          return LoadingOverlay(
            isLoading: controller.isLoading.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile Info Card
                Obx(() => ProfileInfoCard(
                      name: controller.userDetails.value?.fullname ?? "Unknown",
                      phone: controller.userDetails.value?.phone ?? "-",
                      email: controller.userDetails.value?.email ?? "-",
                      subscriptionStatus: dashboardController.isSubscribed.value ? "Active ✅" : "Not Subscribed ❌",
                      profileImage:
                          (controller.userDetails.value?.profileImgUrl != null && controller.userDetails.value!.profileImgUrl!.isNotEmpty)
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
                      icon: Icons.workspace_premium_outlined,
                      title: "Subscription".tr,
                      expandedContent: Obx(() {
                        final isSubscribed = dashboardController.isSubscribed.value;
                        final startDate = dashboardController.planStartDate.value;
                        final endDate = dashboardController.planEndDate.value;

                        final remainingDays = controller.calculateRemainingDays(startDate, endDate);
                        final remainingHours = controller.calculateRemainingHours(endDate);

                        final showHours = remainingDays == 0 && remainingHours > 0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* // Status
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Status - ",
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.blackColor,
                                      fontFamily: semiBoldFont,
                                    ),
                                  ),
                                  TextSpan(
                                    text: isSubscribed ? "Active ✅" : "Not Subscribed ❌",
                                    style: TextHelper.size18.copyWith(
                                      color: isSubscribed ? ColorsForApp.green : Colors.redAccent,
                                      fontFamily: semiBoldFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(0.4.h),*/

                            // Plan name
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Active Plan - ",
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.blackColor,
                                      fontFamily: regularFont,
                                    ),
                                  ),
                                  TextSpan(
                                    text: dashboardController.subscriptionPlan.value,
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.colorBlackShade,
                                      fontFamily: semiBoldFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(0.4.h),

                            // Start Date
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Last Recharge Date - ",
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.blackColor,
                                      fontFamily: regularFont,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.formatDateTime(startDate),
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.colorBlackShade,
                                      fontFamily: semiBoldFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(0.4.h),

                            // End Date
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "End Recharge Date - ",
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.blackColor,
                                      fontFamily: regularFont,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.formatDateTime(endDate),
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.colorBlackShade,
                                      fontFamily: semiBoldFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(0.4.h),

                            // Remaining
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Remaining - ",
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.blackColor,
                                      fontFamily: regularFont,
                                    ),
                                  ),
                                  TextSpan(
                                    text: showHours ? "$remainingHours hours" : "$remainingDays days",
                                    style: TextHelper.size18.copyWith(
                                      color: ColorsForApp.colorBlackShade,
                                      fontFamily: semiBoldFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Manage / Subscribe button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsForApp.primaryDarkColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => Get.toNamed(Routes.SUBSCRIPTION),
                              child: Text(
                                isSubscribed ? "Manage Plan" : "Subscribe Now",
                                style: TextHelper.size18.copyWith(
                                  color: Colors.white,
                                  fontFamily: semiBoldFont,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SettingItem(
                      icon: Icons.notifications_outlined,
                      title: "notifications".tr,
                      hasSwitch: true,
                      switchValue: Config.isNotificationSound.value,
                      toggleValue: Config.isNotificationEnabled,
                      onToggle: (val) async {
                        await controller.toggleNotifications(val);
                        debugPrint("✅ Notifications toggled to $val");
                      },
                    ),
                    SettingItem(
                      icon: Icons.security_outlined,
                      title: "privacy_security".tr,
                      onTap: () async {
                        // For Privacy Policy
                        await UrlLauncherHelper.openUrl("https://quickcabpune.com/privacy-policy.html");
                      },
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
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("choose_language".tr,
                                    style: TextHelper.h5.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
                                const SizedBox(height: 16),
                                ListTile(
                                  title: Text("English",
                                      style: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
                                  onTap: () {
                                    controller.changeLanguage("English");
                                    Get.updateLocale(Locale('en', 'US')); // Switch to Hindi
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  title: Text("हिंदी",
                                      style: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
                                  onTap: () {
                                    controller.changeLanguage("हिंदी");
                                    Get.updateLocale(Locale('hi', 'IN')); // Switch to Hindi
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  title: Text("मराठी",
                                      style: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
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
                                    Get.updateLocale(Locale('kn', 'IN')); // Kannada locale code
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SettingItem(
                      icon: Icons.share_outlined,
                      title: "Share App",
                      onTap: () {
                        controller.shareAppLink();
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
          );
        }),
      ),
    );
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
            style: TextHelper.h7.copyWith(fontFamily: boldFont, color: ColorsForApp.blackColor),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
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
                  highlightColor: ColorsForApp.primaryColor.withValues(alpha: 0.2),
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
                    bool result = await controller.logoutAPI();

                    if (result) {
                      Get.back();

                      // 1. Clear persistent storage
                      await LocalStorage.erase();
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      debugPrint("Prefs after clear: ${prefs.getKeys()}"); // debug

                      ShowSnackBar.success(
                        title: "Logout",
                        message: "You have been logged out successfully!",
                      );

                      // 6. Then navigate
                      Future.delayed(Duration(milliseconds: 300), () {
                        Get.offAllNamed(Routes.LOGIN_SCREEN);
                      });
                    }
                  },
                  splashColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
                  highlightColor: ColorsForApp.primaryColor.withValues(alpha: 0.2),
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

  Widget buildSubscriptionPlans() {
    return Obx(() {
      final isSubscribed = dashboardController.isSubscribed.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSubscribed ? "Your Subscription is Active ✅" : "No Active Subscription ❌",
            style: TextHelper.size18.copyWith(
              color: isSubscribed ? ColorsForApp.green : Colors.redAccent,
              fontFamily: boldFont,
            ),
          ),
          const SizedBox(height: 10),
          if (!isSubscribed) ...[
            _planTile("Basic Plan", "₹499 / month", "Access to basic features"),
            _planTile("Pro Plan", "₹999 / month", "Access to all premium features"),
            const SizedBox(height: 8),
          ],
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsForApp.primaryDarkColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Get.toNamed(Routes.SUBSCRIPTION),
            child: Text(
              isSubscribed ? "Manage Subscription" : "Subscribe Now",
              style: TextHelper.size18.copyWith(
                color: Colors.white,
                fontFamily: semiBoldFont,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _planTile(String name, String price, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsForApp.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextHelper.size18.copyWith(fontFamily: semiBoldFont)),
              Text(desc, style: TextHelper.size16.copyWith(color: Colors.grey)),
            ],
          ),
          Text(price, style: TextHelper.size18.copyWith(color: ColorsForApp.green)),
        ],
      ),
    );
  }
}
