import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../landing_page/controller/dashboard_controller.dart';
import '../controller/home_controller.dart';
import '../home_widgets/driver_network_status.dart';
import '../home_widgets/emergency_service_item.dart';
import '../home_widgets/lead_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the parent state of BottomNavExample
// Get the DashboardController
    final DashboardController dashboardController = Get.find();

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
              Text("Shared Leads", style: TextHelper.h6.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
              GestureDetector(
                  onTap: () {
                    dashboardController.currentIndex.value = 1;
                  },
                  child:
                      Text("View All", style: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.primaryDarkColor))),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Column(
                children: controller.leads.map((lead) => LeadCard(lead: lead)).toList(),
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
