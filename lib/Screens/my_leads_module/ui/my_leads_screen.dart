import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/no_data_found.dart';
import '../../../widgets/shimmer_widget.dart';
import '../../post_lead_module/controller/post_controller.dart';
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
                      child: TabBarView(
                        children: [
                          // Active Leads Tab
                          Obx(
                            () => RefreshIndicator(
                              onRefresh: () async {
                                await controller.fetchLeads();
                              },
                              child: controller.filteredActiveLeads.isEmpty
                                  ? ListView(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        SizedBox(
                                          height: 500, // or use MediaQuery
                                          child: Center(
                                            child: NoDataFoundScreen(
                                              title: "NO LEADS FOUND",
                                              subTitle: "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
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
                                    ),
                            ),
                          ),
                          // Completed Leads Tab
                          Obx(() => RefreshIndicator(
                                onRefresh: () async {
                                  await controller.fetchLeads();
                                },
                                child: controller.filteredCompletedLeads.isEmpty
                                    ? ListView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        children: const [
                                          Center(
                                            child: NoDataFoundScreen(
                                              title: "NO LEADS FOUND",
                                              subTitle: "",
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        itemCount: controller.filteredCompletedLeads.length,
                                        itemBuilder: (_, index) => LeadCard(
                                          lead: controller.filteredCompletedLeads[index],
                                          onShare: () => print("Share"),
                                          onEdit: () {
                                            controller.setLeadData(controller.filteredCompletedLeads[index]);
                                            controller.selectedId.value = controller.filteredCompletedLeads[index].id!;
                                            showEditLeadBottomSheet(context, controller);
                                          },
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

  void showEditLeadBottomSheet(BuildContext context, MyLeadsController controller) {
    final locCtrl = Get.put(PostController(), permanent: true);
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
                        text: controller.formattedDate,
                      ),
                      style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                      decoration: InputDecoration(
                        labelText: "Date",
                        labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                        prefixIcon: Icon(Icons.edit_calendar, color: ColorsForApp.primaryDarkColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onTap: () => controller.selectFromDate(context),
                    )),
                const SizedBox(height: 16),

                // ⏰ Time Picker
                Obx(() => TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: controller.formattedTime(context),
                      ),
                      style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                      decoration: InputDecoration(
                        labelText: "Time",
                        labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                        prefixIcon: Icon(Icons.access_time, color: ColorsForApp.primaryDarkColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onTap: () => controller.selectFromTime(context),
                    )),
                const SizedBox(height: 16),

                // From Location
                TextFormField(
                  controller: controller.fromLocationController,
                  // onTap: () => controller.isEditing.value = true,
                  onChanged: (val) {
                    controller.fromLocation.value = val;
                    // Optional: directly fetch suggestions if you want
                    if (val.length >= 3) {
                      controller.fetchLocations(val, isPickup: true);
                    }
                  },
                  style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                  decoration: InputDecoration(
                    labelText: "Location From",
                    labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                    prefixIcon: Icon(Icons.location_on_outlined, color: ColorsForApp.primaryDarkColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                // suggestions container
                Obx(() {
                  if (controller.isLoadingPickup.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(minHeight: 2),
                    );
                  }

                  if (!controller.showPickupSuggestions.value || controller.pickupSuggestions.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: controller.pickupSuggestions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = controller.pickupSuggestions[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(item['name'] ?? '',
                                style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                            subtitle: Text(item['address'] ?? '',
                                style: TextHelper.size16.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont)),
                            onTap: () => controller.selectSuggestion(isPickup: true, name: item['name'] ?? ''),
                          );
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // To Location
                TextFormField(
                  controller: controller.toLocationController,
                  // onTap: () => controller.isEditing.value = true,
                  onChanged: (val) {
                    controller.toLocation.value = val;
                    if (val.length >= 3) {
                      controller.fetchLocations(val, isPickup: false);
                    }
                  },
                  style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                  decoration: InputDecoration(
                    labelText: "To Location",
                    labelStyle: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                    prefixIcon: Icon(Icons.location_on_outlined, color: ColorsForApp.primaryDarkColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                Obx(() {
                  if (controller.isLoadingDrop.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(minHeight: 2),
                    );
                  }

                  if (!controller.showDropSuggestions.value || controller.dropSuggestions.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: controller.dropSuggestions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = controller.dropSuggestions[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on, color: Colors.red),
                            title: Text(
                              item['name'] ?? '',
                              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
                            ),
                            subtitle: Text(item['address'] ?? '',
                                style: TextHelper.size16.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont)),
                            onTap: () => controller.selectSuggestion(isPickup: false, name: item['name'] ?? ''),
                          );
                        },
                      ),
                    ),
                  );
                }),

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
