import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/landing_page/wallet_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_navigation_bar.dart';
import '../../controller/dashboard_controller.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/dialog.dart';
import 'home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  DashboardController dashboardController = Get.find();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (dashboardController.index.value != 0) {
          dashboardController.index.value = 0;
          return;
        }
        bool shouldExit = await _showExitDialog(context);
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        drawer: const CustomDrawer(),
        drawerEdgeDragWidth: 30.w,
        body: Obx(
          () => IndexedStack(
            index: dashboardController.index.value,
            children: const [
              // Home screen
              HomeScreen(),
              WalletScreen(),
              WalletScreen(),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: dashboardController.index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 20.sp,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_add_alt,
                size: 20.sp,
              ),
              label: ' Clients',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.wallet,
                size: 20.sp,
              ),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                size: 20.sp,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz_sharp,
                size: 20.sp,
              ),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await Get.dialog(
          CustomDialog.yesNoDialog(context, title: 'Exit', note: 'Go offline now? Your next ride could be just a tap away!'),
        ) ??
        false;
  }
}
