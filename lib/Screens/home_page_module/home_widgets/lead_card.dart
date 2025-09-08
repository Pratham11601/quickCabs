import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';

/// LeadCard Widget
/// ----------------
/// A reusable card widget to display ride/lead information.
/// Improvements:
/// - Cleaned spacing
/// - Removed hardcoded widths
/// - Used Expanded/Flexible for responsiveness
/// - Added detailed comments for clarity
class LeadCard extends StatelessWidget {
  final Map<String, dynamic> lead; // Lead details
  final VoidCallback? onAccept; // Callback when "Accept" button is pressed

  const LeadCard({
    super.key,
    required this.lead,
    this.onAccept,
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
            /// ---------------- Header Row ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Avatar + Name
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
                        child: Icon(
                          Icons.handshake,
                          color: ColorsForApp.primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${lead['name'] ?? ''}",
                          style: TextHelper.size19.copyWith(
                            color: ColorsForApp.primaryDarkColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Accept / Booked button
                (lead['acceptedById'] != null)
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Booked",
                          style: TextHelper.size18.copyWith(
                            fontFamily: semiBoldFont,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsForApp.primaryColor,
                          foregroundColor: ColorsForApp.whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          "Accept",
                          style: TextHelper.size18.copyWith(
                            fontFamily: semiBoldFont,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      ),
              ],
            ),

            const SizedBox(height: 8),

            /// ---------------- Route Info ----------------
            Row(
              children: [
                /// From
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.navigation_outlined, color: ColorsForApp.green),
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

                /// To
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

                /// Price
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

            const SizedBox(height: 6),

            /// ---------------- Car & Distance Info ----------------
            Row(
              children: [
                /// Car
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car_outlined, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lead['car'],
                          style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Distance
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      lead['distance'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// ---------------- Date & Time ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Date
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['date'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),

                /// Time
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['time'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// ---------------- Phone ----------------
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: ColorsForApp.blackColor),
                const SizedBox(width: 6),
                Text(
                  lead['phone'],
                  style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
