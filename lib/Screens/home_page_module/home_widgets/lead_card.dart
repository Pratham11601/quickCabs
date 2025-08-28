import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';

/// LeadCard Widget
/// ----------------
/// A reusable card widget to display ride/lead information.
/// Cleaned spacing, removed hardcoded widths, and used Expanded/Spacer
/// for proper alignment.
class LeadCard extends StatelessWidget {
  final Map<String, dynamic> lead;
  final VoidCallback? onAccept; // Callback when "Accept Lead" button is pressed

  const LeadCard({
    super.key,
    required this.lead,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(4), // elevation from all sides
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Header Row ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          ColorsForApp.primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.handshake,
                        color: ColorsForApp.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Shared by ${lead['name']}",
                      style: TextHelper.size19.copyWith(
                        color: ColorsForApp.primaryDarkColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            ColorsForApp.primaryColor), // forcefully applies
                        foregroundColor:
                            WidgetStateProperty.all(ColorsForApp.whiteColor),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      child: Text(
                        "Accept",
                        style: TextHelper.size18.copyWith(
                            fontFamily: semiBoldFont,
                            color: ColorsForApp.whiteColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),

            /// ---------------- Route Info ----------------
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.navigation_outlined,
                          color: ColorsForApp.green),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lead['from'],
                          style: TextHelper.size18.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right_alt, color: Colors.black),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lead['to'],
                          style: TextHelper.size18.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "₹${lead['price']}",
                  style: TextHelper.size20.copyWith(
                    color: ColorsForApp.green,
                    fontFamily: semiBoldFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            /// ---------------- Car Info ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_car_outlined,
                        color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      lead['car'],
                      style: TextHelper.size18
                          .copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      lead['distance'],
                      style: TextHelper.size18
                          .copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// ---------------- Date & Time ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['date'],
                      style: TextHelper.size18
                          .copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['time'],
                      style: TextHelper.size18
                          .copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// ---------------- Phone ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['phone'],
                      style: TextHelper.size18
                          .copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
