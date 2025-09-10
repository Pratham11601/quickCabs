import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/shimmer_widget.dart';
import '../controller/my_lead_controller.dart';
import '../lead_widgets/my_lead_card.dart';
import '../lead_widgets/stats_card.dart';

class MyLeadsPage extends StatelessWidget {
  final MyLeadsController controller = Get.put(MyLeadsController());

  MyLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return shimmerLoader(); // 🔹 show shimmer instead of CircularProgressIndicator
        }
        return Column(
          children: [
            // StatsCard - dynamic data
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StatsCard(
                activeLeads: controller.filteredActiveLeads.length,
                completed: controller.filteredCompletedLeads.length,
                totalValue: controller.filteredActiveLeads
                        .fold<double>(0.0, (sum, lead) => sum + (double.tryParse(lead.fare ?? '0') ?? 0.0)) +
                    controller.filteredCompletedLeads.fold<double>(0.0, (sum, lead) => sum + (double.tryParse(lead.fare ?? '0') ?? 0.0)),
              ),
            ),

            // Search + Filter
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => controller.filterLeads(value),
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                      decoration: InputDecoration(
                        hintText: "Search leads...",
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
                    onPressed: () {
                      // You can implement filter action here
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                  )
                ],
              ),
            ),

            // Tabs
            DefaultTabController(
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
                        Tab(text: "Active (${controller.filteredActiveLeads.length})"),
                        Tab(text: "Completed (${controller.filteredCompletedLeads.length})"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Active Leads Tab
                          Obx(() => RefreshIndicator(
                                onRefresh: () async {
                                  await controller.fetchLeads();
                                },
                                child: ListView.builder(
                                  itemCount: controller.filteredActiveLeads.length,
                                  itemBuilder: (_, index) => LeadCard(
                                    lead: controller.filteredActiveLeads[index],
                                    onShare: () => print("Share"),
                                    onEdit: () => print("Edit"),
                                    onDelete: () => print("Delete"),
                                  ),
                                ),
                              )),
                          // Completed Leads Tab
                          Obx(() => RefreshIndicator(
                                onRefresh: () async {
                                  await controller.fetchLeads();
                                },
                                child: ListView.builder(
                                  itemCount: controller.filteredCompletedLeads.length,
                                  itemBuilder: (_, index) => LeadCard(
                                    lead: controller.filteredCompletedLeads[index],
                                    onShare: () => print("Share"),
                                    onEdit: () => print("Edit"),
                                    onDelete: () => print("Delete"),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
