import 'package:QuickCab/Screens/home_page_module/ui/home_screen.dart';
import 'package:QuickCab/Screens/landing_page/controller/dashboard_controller.dart';
import 'package:QuickCab/Screens/my_leads_module/ui/my_leads_screen.dart';
import 'package:QuickCab/Screens/post_lead_module/ui/post_screen.dart';
import 'package:QuickCab/Screens/profile_module/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/constant_widgets.dart';
import '../dashboard_widgets/custom_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.put(DashboardController());

  final List<Widget> pages = [
    HomeScreen(),
    MyLeadsPage(),
    PostScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (EasyLoading.isShow) return;
        return showExitDialog(context);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorsForApp.gradientTop,
                  ColorsForApp.gradientBottom,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const CustomHeader(),
          ),
        ),
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: ColorsForApp.subtle.withOpacity(0.1),
                  offset: const Offset(0, -3),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: BottomAppBar(
              color: ColorsForApp.whiteColor,
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              notchMargin: 6,
              child: SizedBox(
                height: kBottomNavigationBarHeight + 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Home
                    GestureDetector(
                      onTap: () => controller.currentIndex.value = 0,
                      child: buildNavItem(
                        icon: Icons.home_outlined,
                        label: "Home",
                        index: 0,
                        controller: controller,
                      ),
                    ),

                    // My Leads
                    GestureDetector(
                      onTap: () => controller.currentIndex.value = 1,
                      child: buildNavItem(
                        icon: Icons.list,
                        label: "My Leads",
                        index: 1,
                        controller: controller,
                      ),
                    ),

                    // Post Lead (restricted)
                    GestureDetector(
                      onTap: () async {
                        await controller.checkSubscriptionStatus();

                        if (controller.isSubscribed.value) {
                          controller.currentIndex.value = 2; // ✅ navigate to Post Lead
                        } else {
                          showSubscriptionAlertDialog(
                            Get.context!,
                            'Subscription Required',
                            'Your subscription is not active. Please subscribe to post a lead.',
                            () {
                              Get.toNamed(Routes.SUBSCRIPTION);
                            },
                          );
                        }
                      },
                      child: buildNavItem(
                        icon: Icons.add_circle_outline,
                        label: "Post Lead",
                        index: 2,
                        controller: controller,
                      ),
                    ), // Profile
                    GestureDetector(
                      onTap: () => controller.currentIndex.value = 3,
                      child: buildNavItem(
                        icon: Icons.person_2_outlined,
                        label: "Profile",
                        index: 3,
                        controller: controller,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
