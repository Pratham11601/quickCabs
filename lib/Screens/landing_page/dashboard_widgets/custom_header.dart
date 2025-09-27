import 'package:QuickCab/Screens/landing_page/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/assets.dart';
import '../../../utils/text_styles.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(() {
      if (controller.currentIndex.value == 0) {
        // Home Header
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo + Titles
                Row(
                  children: [
                    // App Logo
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black.withValues(alpha: 0.4),
                      child: Image.asset(Assets.iconsLogo, width: 30, height: 30, fit: BoxFit.fill),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Quick Cabs",
                          style: TextHelper.h5.copyWith(
                            color: Colors.white,
                            fontFamily: semiBoldFont,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Driver Dashboard",
                            style: TextHelper.size18.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else if (controller.currentIndex.value == 1) {
        // Profile Header
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Leads",
                  style: TextHelper.h6.copyWith(
                    color: Colors.white,
                    fontFamily: semiBoldFont,
                  ),
                ),
                SizedBox(height: 0.1.h),
                Flexible(
                  child: Text(
                    "Manage your shared leads",
                    style: TextHelper.size18.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (controller.currentIndex.value == 4) {
        // Profile Header
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: TextHelper.h5.copyWith(
                    color: Colors.white,
                    fontFamily: semiBoldFont,
                  ),
                ),
                SizedBox(height: 0.1.h),
                Flexible(
                  child: Text(
                    "Manage your account settings",
                    style: TextHelper.size18.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (controller.currentIndex.value == 3) {
        // Profile Header
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Leads History",
                  style: TextHelper.h5.copyWith(
                    color: Colors.white,
                    fontFamily: semiBoldFont,
                  ),
                ),
                SizedBox(height: 0.1.h),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
