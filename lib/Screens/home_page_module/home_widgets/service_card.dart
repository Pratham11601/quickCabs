import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../controller/service_card_controller.dart';

class EmergencyServiceCard extends StatelessWidget {
  final String title;
  final String location;
  final String serviceType;
  final EmergencyServicesCardController controller = Get.find();

  EmergencyServiceCard({
    super.key,
    required this.title,
    required this.location,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- Title ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextHelper.h7.copyWith(
                    fontFamily: semiBoldFont,
                    color: ColorsForApp.blackColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            /// ---------- Location ----------
            Row(
              children: [
                Icon(Icons.location_on, size: 16.5.sp, color: Colors.grey),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    location,
                    style: TextHelper.size17.copyWith(
                      fontFamily: semiBoldFont,
                      color: ColorsForApp.blackColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            /// ---------- Response time ----------
            Row(
              children: [
                Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                SizedBox(width: 2.w),
                Text(
                  "Response time:",
                  style: TextHelper.size17.copyWith(
                    fontFamily: semiBoldFont,
                    color: ColorsForApp.subtitle, // e.g., grey tone
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.2.h),

            /// ---------- Action Buttons ----------
            Row(
              children: [
                /// Navigate Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement Navigation action
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      foregroundColor: ColorsForApp.blackColor,
                      side: BorderSide(color: Colors.grey.shade200, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      backgroundColor: ColorsForApp.whiteColor,
                    ),
                    icon: Icon(
                      Icons.navigation,
                      color: ColorsForApp.primaryColor,
                    ),
                    label: Text(
                      "Navigate",
                      style: TextHelper.size18.copyWith(
                        fontFamily: semiBoldFont,
                        color: ColorsForApp.blackColor,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                /// Call Now Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement Call action
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      backgroundColor: ColorsForApp.green, // Centralized red color
                      foregroundColor: ColorsForApp.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    icon: Icon(Icons.call),
                    label: Text(
                      "Call Now",
                      style: TextHelper.size18.copyWith(
                        fontFamily: semiBoldFont,
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
