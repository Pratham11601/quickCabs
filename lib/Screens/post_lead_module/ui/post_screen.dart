import 'package:QuickCab/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../controller/post_controller.dart';
import '../post_widgets/post_lead_widgets.dart'; // <- your stepCircle & buildInputField live here

class PostScreen extends StatelessWidget {
  PostScreen({Key? key}) : super(key: key);

  final PostController controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ───────────────────────────── AppBar (kept your design) ─────────────────────────────
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(25.h),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorsForApp.gradientTop, ColorsForApp.gradientBottom],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Step
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("share_new_lead".tr, style: TextHelper.h5.copyWith(color: Colors.white, fontFamily: semiBoldFont)),
                      Obx(() => Text(
                            "step ${controller.step.value} of 3".tr,
                            style: TextHelper.size18.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Row: Left label + Right progress chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.navigation_outlined, color: Colors.white, size: 30),
                    const SizedBox(width: 8),
                    Text("route_details".tr, style: TextHelper.size20.copyWith(color: Colors.white, fontFamily: semiBoldFont)),
                  ]),
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white24,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text(controller.progressPercentLabel,
                            style: TextHelper.size17.copyWith(color: Colors.white, fontFamily: semiBoldFont)),
                      )),
                ],
              ),
              const SizedBox(height: 8),

              // Progress bar
              Obx(() => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: controller.progress,
                      minHeight: 6,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )),
              const SizedBox(height: 10),

              // Stepper labels
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      stepCircle("route".tr, controller.currentStep.value == 0),
                      stepCircle("trip".tr, controller.currentStep.value == 1),
                      stepCircle("pricing".tr, controller.currentStep.value == 2),
                    ],
                  )),
            ],
          ),
        ),
      ),

      // ───────────────────────────────────────── Body ──────────────────────────────────────
      body: SingleChildScrollView(
        child: Obx(() {
          return LoadingOverlay(
            isLoading: controller.isLoading.value,
            child: Column(
              children: [
                Obx(() {
                  switch (controller.currentStep.value) {
                    case 0:
                      return _buildRouteDetails(context);
                    case 1:
                      return _buildTripInformation(context);
                    case 2:
                      return buildPriceConfirmation();
                    default:
                      return _buildRouteDetails(context);
                  }
                }),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    bool isRouteDetails = controller.currentStep.value == 0;
                    final isLastStep = controller.currentStep.value == 2; //  2 is your last page (Price Confirmation)

                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isRouteDetails ? controller.cancel : controller.previousStep,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              isRouteDetails ? "cancel".tr : "previous".tr,
                              style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isFormValid.value
                                ? () async {
                                    if (controller.currentStep.value == 2) {
                                      await controller.submitRideLead();
                                    } else {
                                      controller.nextStep();
                                    }
                                  }
                                : null,
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
                              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                (states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return ColorsForApp.cta;
                                  }
                                  return ColorsForApp.primaryColor;
                                },
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            child: Text(
                              isLastStep ? "share_lead".tr : "next_step".tr,
                              style: TextHelper.size20.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ),

      // ───────────────────────────────────── Bottom Buttons ─────────────────────────────────
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: Obx(() {
      //     bool isRouteDetails = controller.currentStep.value == 0;
      //     final isLastStep = controller.currentStep.value == 2; //  2 is your last page (Price Confirmation)
      //
      //     return Row(
      //       children: [
      //         Expanded(
      //           child: ElevatedButton(
      //             onPressed: isRouteDetails ? controller.cancel : controller.previousStep,
      //             style: ElevatedButton.styleFrom(
      //               padding: const EdgeInsets.symmetric(vertical: 14),
      //               backgroundColor: Colors.grey.shade200,
      //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //             ),
      //             child: Text(
      //               isRouteDetails ? "cancel".tr : "previous".tr,
      //               style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor),
      //             ),
      //           ),
      //         ),
      //         const SizedBox(width: 12),
      //         Expanded(
      //           child: ElevatedButton(
      //             onPressed: controller.isFormValid.value
      //                 ? () async {
      //                     if (controller.currentStep.value == 2) {
      //                       await controller.submitRideLead();
      //                     } else {
      //                       controller.nextStep();
      //                     }
      //                   }
      //                 : null,
      //             style: ButtonStyle(
      //               minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
      //               backgroundColor: WidgetStateProperty.resolveWith<Color>(
      //                 (states) {
      //                   if (states.contains(WidgetState.disabled)) {
      //                     return ColorsForApp.cta;
      //                   }
      //                   return ColorsForApp.primaryColor;
      //                 },
      //               ),
      //               shape: WidgetStateProperty.all(
      //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //               ),
      //             ),
      //             child: Text(
      //               isLastStep ? "share_lead".tr : "next_step".tr,
      //               style: TextHelper.size20.copyWith(color: Colors.white),
      //             ),
      //           ),
      //         ),
      //       ],
      //     );
      //   }),
      // ),
    );
  }

  // ─────────────────────────────────── Step 1: Route Details ───────────────────────────────────
  Widget _buildRouteDetails(BuildContext context) {
    final PostController locCtrl = Get.find<PostController>(); // your controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... other widgets above

          // PICKUP FIELD + SUGGESTIONS
          buildInputField(
            "pick_up_location".tr,
            "enter_pick_up_location".tr,
            Icons.location_on_outlined,
            Colors.green,
            locCtrl.pickupController,
            focusNode: locCtrl.pickupFocus,
            onChanged: (val) => locCtrl.debouncePickup.value = val,
          ),

          // small gap
          const SizedBox(height: 6),

          // suggestions container
          Obx(() {
            if (locCtrl.isLoadingPickup.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(minHeight: 2),
              );
            }

            if (!locCtrl.showPickupSuggestions.value || locCtrl.pickupSuggestions.isEmpty) {
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
                  itemCount: locCtrl.pickupSuggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = locCtrl.pickupSuggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(item['name'] ?? '',
                          style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                      subtitle: Text(item['address'] ?? '',
                          style: TextHelper.size16.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont)),
                      onTap: () => locCtrl.selectSuggestion(isPickup: true, name: item['name'] ?? ''),
                    );
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // DROP FIELD + SUGGESTIONS
          buildInputField(
            "drop_off_location".tr,
            "enter_drop_off_location".tr,
            Icons.location_on,
            Colors.red,
            locCtrl.dropController,
            focusNode: locCtrl.dropFocus,
            onChanged: (val) => locCtrl.debounceDrop.value = val,
          ),

          const SizedBox(height: 6),

          Obx(() {
            if (locCtrl.isLoadingDrop.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(minHeight: 2),
              );
            }

            if (!locCtrl.showDropSuggestions.value || locCtrl.dropSuggestions.isEmpty) {
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
                  itemCount: locCtrl.dropSuggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = locCtrl.dropSuggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: Text(
                        item['name'] ?? '',
                        style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
                      ),
                      subtitle: Text(item['address'] ?? '',
                          style: TextHelper.size16.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont)),
                      onTap: () => locCtrl.selectSuggestion(isPickup: false, name: item['name'] ?? ''),
                    );
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          Text(
            "Trip Type",
            style: TextHelper.size20.copyWith(
              color: ColorsForApp.blackColor,
              fontFamily: boldFont,
            ),
          ),
          const SizedBox(height: 12),

          _tripTypeCard(
            "return_trip".tr,
            "round_trip_journey".tr,
            Icons.autorenew,
            Colors.blue,
          ),
          _tripTypeCard(
            "one_way".tr,
            "single_journey".tr,
            Icons.arrow_forward,
            Colors.orange,
          ),
          _tripTypeCard(
            "rented".tr,
            "daily_rental".tr,
            Icons.calendar_today,
            Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────── Step 2: Trip Information ────────────────────────────────
  Widget _buildTripInformation(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("trip_information".tr, style: TextHelper.h7.copyWith(color: ColorsForApp.blackColor, fontFamily: boldFont)),
        const SizedBox(height: 16),
        Text("vehicle_type".tr, style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
        const SizedBox(height: 8),

        // Vehicle Grid (static grid; each item is reactive)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.vehicles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final vehicle = controller.vehicles[index];

            return Obx(() {
              final bool isSelected = controller.selectedVehicleIndex.value == index;
              final Color color = vehicle["color"] as Color;
              final String name = vehicle["name"] as String;
              final String seats = (vehicle["seats"] as String?) ?? "";

              return GestureDetector(
                onTap: () => controller.selectVehicle(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.2) : Colors.white,
                    border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 1, offset: const Offset(0, 3))],
                  ),
                  child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.directions_car, color: color),
                      const SizedBox(height: 6),
                      Text(name, style: TextHelper.size18.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
                      if (seats.isNotEmpty)
                        Text(seats, style: TextHelper.size17.copyWith(color: ColorsForApp.subTitleColor, fontFamily: regularFont)),
                    ]),
                  ),
                ),
              );
            });
          },
        ),

        const SizedBox(height: 16),

        // Seat Configuration (only for vehicles marked with "seatConfig": true)
        Obx(() {
          final int? idx = controller.selectedVehicleIndex.value;
          final bool showConfig = idx != null && (controller.vehicles[idx]["seatConfig"] == true);
          if (!showConfig) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("seat_configuration".tr, style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 3, // 3 items per row
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5, // width / height ratio
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _seatOption("9-seater", 9),
                  _seatOption("13-seater", 13),
                  _seatOption("17-seater", 17),
                  _seatOption("20-seater", 20),
                  _seatOption("27-seater", 27),
                  _seatOption("32-seater", 32),
                  _seatOption("45-seater", 45),
                  _seatOption("50-seater", 50),
                ],
              )
            ],
          );
        }),

        const SizedBox(height: 16),

        // Date & Time pickers
        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectFromDate(context),
              child: Obx(() => _buildInputBox(
                    icon: Icons.calendar_today,
                    text: controller.formattedDate,
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectFromTime(context),
              child: Obx(() => _buildInputBox(
                    icon: Icons.access_time,
                    text: controller.formattedTime(context),
                  )),
            ),
          ),
        ]),
      ]),
    );
  }

  // ─────────────────────────────────── Widgets: small helpers ─────────────────────────────────

  // Trip Type Card (reactive)
  Widget _tripTypeCard(String title, String subtitle, IconData icon, Color color) {
    return Obx(() {
      final bool isSelected = controller.tripType.value == title;
      return GestureDetector(
        onTap: () => controller.selectTripType(title),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? ColorsForApp.primaryColor : Colors.grey.shade300),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, spreadRadius: 1, offset: const Offset(0, 3))],
          ),
          child: Row(children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
              Text(subtitle, style: TextHelper.size17.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont)),
            ]),
          ]),
        ),
      );
    });
  }

  // Seat option (reactive)
  Widget _seatOption(String text, int value) {
    return Obx(() {
      final bool isSelected = controller.selectedSeatConfig.value == value;
      return GestureDetector(
        onTap: () => controller.selectSeatConfig(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.group_outlined, color: ColorsForApp.colorBlue),
                Text(text, style: TextHelper.size18),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Simple input-like box for date/time display (kept local for styling)
  Widget _buildInputBox({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(children: [
        Icon(icon, color: ColorsForApp.primaryColor),
        const SizedBox(width: 8),
        Text(text, style: TextHelper.size18.copyWith(color: ColorsForApp.subTitleColor, fontFamily: semiBoldFont)),
      ]),
    );
  }

  // ─────────────────────────────────── Step 3: Price Confirmation ────────────────────────────────
  Widget buildPriceConfirmation() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("pricing_distance".tr, style: TextHelper.h7.copyWith(color: ColorsForApp.blackColor, fontFamily: boldFont)),
        const SizedBox(height: 6),
        Text(
          "pricing_message".tr,
          style: TextHelper.size18.copyWith(color: ColorsForApp.subTitleColor, fontFamily: regularFont),
        ),
        const SizedBox(height: 16),

        // Your reusable text-fields
        buildInputField(
          "estimated_fare".tr,
          "0",
          Icons.currency_rupee,
          Colors.green,
          controller.fareController,
          isNumeric: true,
        ),
        // const SizedBox(height: 12),
        // buildInputField(
        //   "distance".tr,
        //   "0.0",
        //   Icons.navigation_outlined,
        //   Colors.blue,
        //   controller.distanceController,
        //   isNumeric: true,
        // ),
      ]),
    );
  }
}
