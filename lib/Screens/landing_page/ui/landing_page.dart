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
    callAsyncAPI();
    super.initState();
  }

  Future<void> callAsyncAPI() async {
    // This will internally set controller.isSubscribed.value
    // Call API once when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.checkSubscriptionStatus();
    });
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

                    // 🔹 Post Lead restricted
                    GestureDetector(
                      onTap: () {
                        if (controller.isSubscribed.value == true) {
                          controller.currentIndex.value = 2; // Navigate to Post Lead
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Subscription Required"),
                                content: const Text(
                                  "Your subscription is not active. Please subscribe to post a lead.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      Get.toNamed("/subscription");
                                    },
                                    child: const Text("Subscribe"),
                                  ),
                                ],
                              ),
                            );
                          });
                        }
                      },
                      child: Obx(
                        () => buildNavItem(
                          icon: Icons.add_circle_outline,
                          label: "Post Lead",
                          index: 2,
                          controller: controller,
                        ),
                      ),
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
