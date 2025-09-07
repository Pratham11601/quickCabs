import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuickCab/routes/routes.dart';
import 'package:QuickCab/widgets/constant_widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../landing_page/controller/dashboard_controller.dart';
import '../controller/home_controller.dart';
import '../home_widgets/driver_network_status.dart';
import '../home_widgets/emergency_service_item.dart';
import '../home_widgets/lead_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardController dashboardController = Get.find();
  final HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    callAsyncAPI();
    super.initState();
  }

  Future<void> callAsyncAPI() async {
    bool result = await homeController.checkProfileCompletion();
    if (result) {
      if (!homeController.isKycCompleted.value) {
        showCommonMessageDialog(
          Get.context!,
          'Profile Incomplete',
          'Your profile is not completed please complete you profile',
          () {
            Get.toNamed(Routes.MY_DOCUMENTS);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, top: 25, right: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency services
          EmergencyServicesSection(),
          const SizedBox(height: 20),

          // Leads
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("shared_leads".tr,
                  style: TextHelper.h6.copyWith(
                      fontFamily: semiBoldFont,
                      color: ColorsForApp.blackColor)),
              GestureDetector(
                  onTap: () {
                    dashboardController.currentIndex.value = 1;
                  },
                  child: Text("view_all".tr,
                      style: TextHelper.size19.copyWith(
                          fontFamily: semiBoldFont,
                          color: ColorsForApp.primaryDarkColor))),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
                children: homeController.leads
                    .map((lead) => LeadCard(lead: lead))
                    .toList(),
              )),
          const SizedBox(height: 12),
          Center(
            child: DriverNetworkStatusCard(
              onlineDrivers: 156,
              isActive: true,
              isHighDemand: true,
            ),
          ),
        ],
      ),
    );
  }
}
