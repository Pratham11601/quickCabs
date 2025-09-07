import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuickCab/utils/text_styles.dart';

import '../../../utils/app_colors.dart';
import '../controller/my_lead_controller.dart';
import '../lead_widgets/my_lead_card.dart';
import '../lead_widgets/stats_card.dart';

class MyLeadsPage extends StatelessWidget {
  final MyLeadsController controller = Get.put(MyLeadsController());

  MyLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StatsCard(
              activeLeads: 2,
              completed: 1,
              totalValue: 2950,
            ),
          ),

          // Search + Filter
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                    decoration: InputDecoration(
                      hintText: "search_leads".tr,
                      hintStyle: TextHelper.size18.copyWith(color: ColorsForApp.subTitleColor, fontFamily: regularFont),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt_outlined),
                )
              ],
            ),
          ),

          // Tabs
          Obx(() => DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        labelStyle: TextHelper.size18.copyWith(fontFamily: semiBoldFont),
                        labelColor: ColorsForApp.primaryDarkColor,
                        unselectedLabelColor: Colors.black54,
                        indicatorColor: ColorsForApp.primaryDarkColor,
                        tabs: [
                          Tab(text: "active (${controller.activeLeads.length})".tr),
                          Tab(text: "completed (${controller.completedLeads.length})".tr),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Active Leads
                            Obx(() => ListView.builder(
                                  itemCount: controller.activeLeads.length,
                                  itemBuilder: (_, index) => LeadCard(
                                    lead: controller.activeLeads[index],
                                    onShare: () => print("share".tr),
                                    onEdit: () => print("edit".tr),
                                    onDelete: () => print("delete".tr),
                                  ),
                                )),
                            // Completed Leads
                            Obx(() => ListView.builder(
                                  itemCount: controller.completedLeads.length,
                                  itemBuilder: (_, index) => LeadCard(
                                    lead: controller.completedLeads[index],
                                    onShare: () => print("share".tr),
                                    onEdit: () => print("edit".tr),
                                    onDelete: () => print("delete".tr),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
