import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';
import '../controller/profile_controller.dart';
import '../controller/subscription_controller.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController subscriptionController = Get.find();
    final ProfileController profileController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Subscription",
        subtitle: "Upgrade for exclusive features",
      ),
      body: Obx(() {
        final packages = subscriptionController.packagesModelResponse.value.packages ?? [];

        return LoadingOverlay(
          isLoading: subscriptionController.isLoading.value,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: packages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final pkg = packages[index];
                    final isSelected = subscriptionController.selectedPlanId.value == pkg.id.toString();

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        subscriptionController.selectedPlanId.value = pkg.id.toString();
                        debugPrint("Selected Plan ID: ${subscriptionController.selectedPlanId.value}");
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
                              groupValue: subscriptionController.selectedPlanId.value,
                              onChanged: (val) async {
                                subscriptionController.selectedPlanId.value = val ?? "";

                                // // Also create order on radio selection
                                // if (val != null && val.isNotEmpty) {
                                //   await subscriptionController.createOrderAPI(val);
                                // }
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

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorsForApp.colorBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorsForApp.colorBlue.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Text("Why Choose Quick Cabs Pro?",
                        style: TextHelper.h5.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              BenefitItem(text: "Higher lead priority"),
                              BenefitItem(text: "Faster earnings"),
                              BenefitItem(text: "Premium support"),
                            ],
                          ),
                        ),
                        // Right column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              BenefitItem(text: "Advanced analytics"),
                              BenefitItem(text: "Multiple vehicles"),
                              BenefitItem(text: "Exclusive zones"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Subscribe button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: subscriptionController.selectedPlanId.value.isNotEmpty
                        ? () async {
                            final selectedPkg = packages.firstWhere(
                              (p) => p.id.toString() == subscriptionController.selectedPlanId.value,
                            );

                            // 🔹 Call API here

                            await subscriptionController.createOrderAPI(subscriptionController.selectedPlanId.value);

                            final orderId = subscriptionController.createOrderModelResponse.value.order?.id ?? "";

                            if (orderId.isNotEmpty) {
                              // 🔹 Redirect to Razorpay
                              subscriptionController.openCheckout(
                                orderId: orderId,
                                planId: subscriptionController.selectedPlanId.value,
                                amount: selectedPkg.totalPrice ?? 0,
                                name: profileController.userDetails.value?.fullname ?? "Unknown",
                                contact: profileController.userDetails.value?.phone ?? "-",
                                email: profileController.userDetails.value?.email ?? "-",
                              );
                            } else {
                              Get.snackbar("Error", "Failed to create order. Please try again.");
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: subscriptionController.selectedPlanId.value.isNotEmpty ? ColorsForApp.orange : Colors.grey,
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
          ),
        );
      }),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final String text;
  const BenefitItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextHelper.size17.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
            ),
          ),
        ],
      ),
    );
  }
}
