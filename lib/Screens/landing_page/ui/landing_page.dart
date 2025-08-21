import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/home_page_module/ui/home_screen.dart';
import 'package:own_idea/Screens/landing_page/controller/dashboard_controller.dart';

import '../../../generated/assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  final List<Widget> pages = const [
    HomeScreen(),
    Center(child: Text("My Leads")),
    Center(child: Text("Post Lead")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorsForApp.gradientTop, ColorsForApp.gradientBottom], // Orange to Red gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        // Title & Subtitle
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
                            Text(
                              "Driver Dashboard",
                              style: TextHelper.size16.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Notification Icon
                    const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: pages[controller.currentIndex.value],
        // Custom BottomAppBar
        bottomNavigationBar: Obx(() {
          return Container(
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: ColorsForApp.subtle.withValues(alpha: 0.1), // shadow color
                  offset: const Offset(0, -3), // upward shadow
                  blurRadius: 6, // softness
                  spreadRadius: 1,
                ),
              ],
            ),
            child: BottomAppBar(
              color: ColorsForApp.whiteColor,
              elevation: 0, // shadow depth
              shadowColor: Colors.black.withOpacity(0.2),
              shape: const CircularNotchedRectangle(),
              notchMargin: 6,
              child: SizedBox(
                height: kBottomNavigationBarHeight + 10, // responsive default height
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Home
                    buildNavItem(
                      icon: Icons.home_outlined,
                      label: "Home",
                      index: 0,
                      controller: controller,
                    ),

                    // My Leads
                    buildNavItem(
                      icon: Icons.list,
                      label: "My Leads",
                      index: 1,
                      controller: controller,
                    ),

                    // My Leads
                    buildNavItem(
                      icon: Icons.add_circle_outline,
                      label: "Post Lead",
                      index: 2,
                      controller: controller,
                    ),

                    // Profile
                    buildNavItem(
                      icon: Icons.person_2_outlined,
                      label: "Profile",
                      index: 3,
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
