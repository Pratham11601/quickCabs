import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';
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
        preferredSize: const Size.fromHeight(230),
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
                      Text("Share New Lead", style: TextHelper.h5.copyWith(color: Colors.white, fontFamily: semiBoldFont)),
                      Obx(() => Text(
                            "Step ${controller.step.value} of 3",
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
                    Text("Route Details", style: TextHelper.size20.copyWith(color: Colors.white, fontFamily: semiBoldFont)),
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
                      stepCircle("Route", controller.currentStep.value == 0),
                      stepCircle("Trip", controller.currentStep.value == 1),
                      stepCircle("Pricing", controller.currentStep.value == 2),
                    ],
                  )),
            ],
          ),
        ),
      ),

      // ───────────────────────────────────────── Body ──────────────────────────────────────
      body: Obx(() {
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

      // ───────────────────────────────────── Bottom Buttons ─────────────────────────────────
      bottomNavigationBar: Padding(
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
                    isRouteDetails ? "Cancel" : "Previous",
                    style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isFormValid.value
                      ? () {
                          if (controller.currentStep.value == 2) {
                            // Last step → show success dialog
                            showAppDialog(
                              title: 'Lead Shared Successfully',
                              message:
                                  'Your ride lead has been shared with the driver network. Other drivers can now see and contact you for this trip.',
                              icon: Icons.check_circle_rounded,
                              buttonText: 'OK',
                              onConfirm: () {
                                Get.offAllNamed(Routes.DASHBOARD_PAGE);
                              },
                            );
                          } else {
                            // Otherwise → go to next step
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
                    isLastStep ? "Share Lead" : "Next Step",
                    style: TextHelper.size20.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────── Step 1: Route Details ───────────────────────────────────
  Widget _buildRouteDetails(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Route Details", style: TextHelper.h7.copyWith(color: ColorsForApp.blackColor, fontFamily: boldFont)),
        const SizedBox(height: 6),
        Text(
          "Enter the pickup and drop-off locations for this ride",
          style: TextHelper.size18.copyWith(color: ColorsForApp.subTitleColor, fontFamily: regularFont),
        ),
        const SizedBox(height: 16),

        // Your reusable text-fields
        buildInputField(
          "Pick-up Location",
          "Enter pick-up location",
          Icons.location_on_outlined,
          Colors.green,
          controller.pickupController,
        ),
        const SizedBox(height: 12),
        buildInputField(
          "Drop-off Location",
          "Enter drop-off location",
          Icons.location_on,
          Colors.red,
          controller.dropController,
        ),

        const SizedBox(height: 20),
        Text("Trip Type", style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: boldFont)),
        const SizedBox(height: 12),

        // Each card is reactive on its own
        _tripTypeCard("Return Trip", "Round trip journey", Icons.autorenew, Colors.blue),
        _tripTypeCard("One Way", "Single journey", Icons.arrow_forward, Colors.orange),
        _tripTypeCard("Rented", "Hourly/Daily rental", Icons.calendar_today, Colors.blueAccent),
      ]),
    );
  }

  // ─────────────────────────────────── Step 2: Trip Information ────────────────────────────────
  Widget _buildTripInformation(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Trip Information", style: TextHelper.h7.copyWith(color: ColorsForApp.blackColor, fontFamily: boldFont)),
        const SizedBox(height: 16),
        Text("Vehicle Type", style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
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
              Text("Seat Configuration", style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
              const SizedBox(height: 8),
              Row(children: [
                _seatOption("7-seater", 7),
                const SizedBox(width: 8),
                _seatOption("8-seater", 8),
              ]),
            ],
          );
        }),

        const SizedBox(height: 16),

        // Date & Time pickers
        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.pickDate(context),
              child: Obx(() => _buildInputBox(
                    icon: Icons.calendar_today,
                    text: controller.formattedDate,
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.pickTime(context),
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
    return Expanded(
      child: Obx(() {
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
              children: [
                Icon(Icons.group_outlined, color: ColorsForApp.colorBlue),
                Text(text, style: TextHelper.size18),
              ],
            )),
          ),
        );
      }),
    );
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
        Text("Pricing & Distance", style: TextHelper.h7.copyWith(color: ColorsForApp.blackColor, fontFamily: boldFont)),
        const SizedBox(height: 6),
        Text(
          "Set the estimated fare and distance for this trip",
          style: TextHelper.size18.copyWith(color: ColorsForApp.subTitleColor, fontFamily: regularFont),
        ),
        const SizedBox(height: 16),

        // Your reusable text-fields
        buildInputField(
          "Estimated Fare (₹)",
          "0",
          Icons.currency_rupee,
          Colors.green,
          controller.fareController,
          isNumeric: true,
        ),
        const SizedBox(height: 12),
        buildInputField(
          "Distance (km)",
          "0.0",
          Icons.navigation_outlined,
          Colors.blue,
          controller.distanceController,
          isNumeric: true,
        ),
      ]),
    );
  }
}
