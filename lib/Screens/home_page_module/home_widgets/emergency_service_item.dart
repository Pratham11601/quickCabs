import 'package:flutter/material.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';

import '../../../generated/assets.dart';

class EmergencyServicesSection extends StatelessWidget {
  const EmergencyServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Badge Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("emergency_services".tr, style: TextHelper.h6.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: ColorsForApp.whiteColor, size: 16),
                  SizedBox(width: 4),
                  Text("247_available".tr, style: TextHelper.size17.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.whiteColor)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal List
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.10, // 12% of screen height
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildServiceCard(
                    Image.asset(
                      Assets.iconsPuncture,
                      height: 32,
                    ),
                    "puncture".tr,
                    Colors.green.shade50,
                    Colors.green),
                buildServiceCard(
                    Image.asset(
                      Assets.iconsHospital,
                      height: 32,
                    ),
                    "hospital".tr,
                    Colors.blue.shade50,
                    Colors.blue),
                buildServiceCard(
                    Image.asset(
                      Assets.iconsHotel,
                      height: 32,
                    ),
                    "hotel".tr,
                    Colors.red.shade50,
                    Colors.red),
                buildServiceCard(
                    Image.asset(
                      Assets.iconsCab,
                      height: 32,
                    ),
                    "cab".tr,
                    Colors.orange.shade50,
                    Colors.orange),
                buildServiceCard(
                    Image.asset(
                      Assets.iconsDriver,
                      height: 32,
                    ),
                    "driver".tr,
                    Colors.lightGreen.shade50,
                    Colors.green),
                buildServiceCard(
                    Image.asset(
                      Assets.iconsFuel,
                      height: 32,
                    ),
                    "fuel".tr,
                    Colors.red.shade50,
                    Colors.red),
                buildServiceCard(
                    Image.asset(
                      Assets.iconsTowing,
                      height: 32,
                    ),
                    "towing".tr,
                    Colors.blueGrey.shade50,
                    Colors.black),
                buildServiceCard(
                    Image.asset(
                      Assets.iconsCarSell,
                      height: 32,
                    ),
                    "car_sell".tr,
                    Colors.blue.shade50,
                    Colors.blueAccent),
              ],
            ),
          ),
        ),

        // Scroll Indicator (fake)
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: 0.5, // adjust dynamically if needed
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black54.withValues(alpha: 0.2)),
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  Widget buildServiceCard(dynamic icon, String title, Color bgColor, Color textColor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon is IconData
              ? Icon(
                  icon,
                )
              : icon,
          const SizedBox(height: 10),
          Text(title, style: TextHelper.size18.copyWith(color: textColor, fontFamily: semiBoldFont)),
        ],
      ),
    );
  }
}
