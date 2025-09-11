import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/shimmer_widget.dart';
import '../controller/my_lead_controller.dart';
import '../lead_widgets/completed_card.dart';
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
          return shimmerLoader();
        }
        return Column(
          children: [
            // StatsCard
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
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt_outlined),
                  )
                ],
              ),
            ),

            // Tabs + TabBarView
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

                    // ✅ One RefreshIndicator for the whole TabBarView
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchLeads(forceRefresh: true);
                        },
                        child: TabBarView(
                          children: [
                            // Active Leads Tab
                            Obx(() => ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredActiveLeads.length,
                                  itemBuilder: (_, index) => LeadCard(
                                    lead: controller.filteredActiveLeads[index],
                                    onShare: () => print("Share"),
                                    onEdit: () {
                                      controller.setLeadData(controller.filteredActiveLeads[index]);
                                      controller.selectedId.value = controller.filteredActiveLeads[index].id!;
                                      showEditLeadBottomSheet(context, controller);
                                    },
                                    onDelete: () => print("Delete"),
                                  ),
                                )),

                            // Completed Leads Tab
                            Obx(() => ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredCompletedLeads.length,
                                  itemBuilder: (_, index) => CompletedLeadCard(
                                    lead: controller.filteredCompletedLeads[index],
                                  ),
                                )),
                          ],
                        ),
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

  void showEditLeadBottomSheet(BuildContext context, MyLeadsController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 👈 allows full height scroll
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20, // handle keyboard
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // 👈 wrap content
              children: [
                // Header Row
                Row(
                  children: [
                    Icon(Icons.edit, color: ColorsForApp.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Edit Lead",
                      style: TextHelper.h7.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: boldFont,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(),

                // ✅ Your same form fields from AlertDialog
                const SizedBox(height: 16),

                // Trip Active
                /*Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Trip Active",
                        style: TextHelper.size19.copyWith(
                          color: ColorsForApp.blackColor,
                          fontFamily: regularFont,
                        ),
                      ),
                    ),
                    Obx(() => Switch(
                          value: controller.isTripActive.value,
                          onChanged: (val) => controller.isTripActive.value = val,
                          activeColor: Colors.white,
                          activeTrackColor: Colors.redAccent,
                        )),
                  ],
                ),*/
                const SizedBox(height: 16),

                // 📅 Date Picker
                Obx(() => TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text:
                            "${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}",
                      ),
                      style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                      decoration: InputDecoration(
                        labelText: "Date",
                        labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                        prefixIcon: Icon(Icons.edit_calendar, color: ColorsForApp.primaryDarkColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) controller.selectedDate.value = picked;
                      },
                    )),
                const SizedBox(height: 16),

                // ⏰ Time Picker
                Obx(() => TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: "${controller.selectedTime.value.hour}:${controller.selectedTime.value.minute.toString().padLeft(2, '0')}",
                      ),
                      style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                      decoration: InputDecoration(
                        labelText: "Time",
                        labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                        prefixIcon: Icon(Icons.access_time, color: ColorsForApp.primaryDarkColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedTime.value,
                        );
                        if (picked != null) controller.selectedTime.value = picked;
                      },
                    )),
                const SizedBox(height: 16),

                // From Location
                Obx(() => TextFormField(
                      controller: TextEditingController(text: controller.fromLocation.value)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.fromLocation.value.length),
                        ),
                      style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                      decoration: InputDecoration(
                        labelText: "Location From",
                        labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                        prefixIcon: Icon(Icons.location_on_outlined, color: ColorsForApp.primaryDarkColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) => controller.fromLocation.value = val,
                    )),
                const SizedBox(height: 16),

                // To Location
                Obx(() => TextFormField(
                      controller: TextEditingController(text: controller.toLocation.value)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.toLocation.value.length),
                        ),
                      style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                      decoration: InputDecoration(
                        labelText: "To Location",
                        labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                        prefixIcon: Icon(Icons.location_on_outlined, color: ColorsForApp.primaryDarkColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) => controller.toLocation.value = val,
                    )),
                const SizedBox(height: 16),

                // Car Model
                TextFormField(
                  controller: controller.carModelController,
                  style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                  decoration: InputDecoration(
                    labelText: "Car Model",
                    labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                    prefixIcon: Icon(Icons.directions_car, color: ColorsForApp.primaryDarkColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Fare
                TextFormField(
                  controller: controller.fareController,
                  style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                  decoration: InputDecoration(
                    labelText: "Fare",
                    labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                    prefixIcon: Icon(Icons.currency_rupee, color: ColorsForApp.primaryDarkColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // ✅ Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          bool response = await controller.editRideLead();
                          if (response == true) {
                            showAppDialog(
                              title: "Success",
                              message: controller.editModelResponse.value.message.toString(),
                              icon: Icons.check_circle_rounded,
                              buttonText: 'OK',
                              onConfirm: () async {
                                await controller.fetchLeads();
                                Get.back();
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsForApp.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Save", style: TextHelper.size20.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                      ),
                    ),
                    // const SizedBox(width: 10),
                    // Expanded(
                    //   child: OutlinedButton(
                    //     onPressed: () => Get.back(),
                    //     style: OutlinedButton.styleFrom(
                    //       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    //     ),
                    //     child: Text("Cancel", style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
