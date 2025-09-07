import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../controller/profile_controller.dart';
import '../controller/subscription_controller.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    final profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
        ),
        title: Text(
          'Subscription',
          style: TextHelper.size20.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsForApp.orange,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final packages = controller.packagesModelResponse.value.packages ?? [];

        if (packages.isEmpty) {
          return const Center(child: Text("No packages available"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: packages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  final isSelected = controller.selectedPlanId.value == pkg.id.toString();

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      controller.selectedPlanId.value = pkg.id.toString();

                      // Call order creation here so it's ready in advance
                      await controller.createOrderAPI(pkg.id.toString());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? ColorsForApp.orange.withOpacity(0.1) : Colors.grey[100],
                        border: Border.all(
                          color: isSelected ? ColorsForApp.orange : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: pkg.id.toString(),
                            groupValue: controller.selectedPlanId.value,
                            onChanged: (val) async {
                              controller.selectedPlanId.value = val ?? "";

                              // Also create order on radio selection
                              if (val != null && val.isNotEmpty) {
                                await controller.createOrderAPI(val);
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pkg.packageName ?? "Unnamed",
                                  style: TextHelper.size20.copyWith(
                                    fontFamily: semiBoldFont,
                                    color: isSelected ? ColorsForApp.orange : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${pkg.durationInDays} days - ₹ ${pkg.pricePerDay} per day",
                                  style: TextHelper.size17.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "₹ ${pkg.totalPrice}",
                            style: TextHelper.size18.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? ColorsForApp.orange : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Subscribe button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.selectedPlanId.value.isNotEmpty
                      ? () {
                          final selectedPkg = packages.firstWhere(
                            (p) => p.id.toString() == controller.selectedPlanId.value,
                          );

                          controller.openCheckout(
                            orderId: controller.createOrderModelResponse.value.order!.id ?? "",
                            planId: controller.selectedPlanId.value,
                            amount: selectedPkg.totalPrice ?? 0,
                            name: profileController.userDeatils.value.fullname ?? "unknown", // user’s full name
                            contact: profileController.userDeatils.value.phone ?? "-", // user’s mobile
                            email: profileController.userDeatils.value.email ?? "-", // user’s email
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: controller.selectedPlanId.value.isNotEmpty ? ColorsForApp.orange : Colors.grey,
                  ),
                  child: Text(
                    "Subscribe",
                    style: TextHelper.size20.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
