import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/home_page_module/ui/home_screen.dart';
import 'package:own_idea/Screens/landing_page/controller/dashboard_controller.dart';
import 'package:own_idea/Screens/my_leads_module/ui/my_leads_screen.dart';
import 'package:own_idea/Screens/post_lead_module/ui/post_screen.dart';
import 'package:own_idea/Screens/profile_module/ui/profile_screen.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/constant_widgets.dart';
import '../dashboard_widgets/custom_header.dart';

class DashboardScreen extends GetView<DashboardController> {

  DashboardScreen({super.key});

  final List<Widget> pages = [
     HomeScreen(),
    MyLeadsPage(),
    PostScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
            canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (EasyLoading.isShow ) {
          return;
        } else {
          return showExitDialog(context);
        }
      },
      child: Scaffold(
        /// AppBar with dynamic header
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
      
        /// Body → only IndexedStack reacts
        body: Obx(() => IndexedStack(
              index: controller.currentIndex.value,
              children: pages,
            )),
      
        /// ✅ Bottom Navigation → only reacts to controller
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
                    buildNavItem(
                      icon: Icons.home_outlined,
                      label: "Home",
                      index: 0,
                      controller: controller,
                    ),
                    buildNavItem(
                      icon: Icons.list,
                      label: "My Leads",
                      index: 1,
                      controller: controller,
                    ),
                    buildNavItem(
                      icon: Icons.add_circle_outline,
                      label: "Post Lead",
                      index: 2,
                      controller: controller,
                    ),
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
          ),
        ),
      ),
    );
  }
}
