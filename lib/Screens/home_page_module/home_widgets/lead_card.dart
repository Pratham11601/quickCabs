import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/constant_widgets.dart';

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
  final void Function(String phone)? onWhatsApp; // WhatsApp button callback
  final void Function(String phone)? onCall; // Call button callback

  const LeadCard({
    super.key,
    required this.lead,
    this.onAccept,
    this.onWhatsApp,
    this.onCall,
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
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Booking Id - ",
                        style: TextHelper.size18.copyWith(
                          color: ColorsForApp.subtle,
                          fontFamily: semiBoldFont,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "QCS${lead['id'] ?? ''}",
                          style: TextHelper.size18.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16), // space between Booking Id and Trip Type

                /// Trip Type
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // push text to the right
                    children: [
                      Text(
                        "Trip Type - ",
                        style: TextHelper.size18.copyWith(
                          color: ColorsForApp.subtle,
                          fontFamily: semiBoldFont,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          lead['trip_type'] == 0
                              ? "Oneway"
                              : lead['trip_type'] == 1
                                  ? "Return"
                                  : lead['trip_type'] == 2
                                      ? "Rented"
                                      : "Other",
                          style: TextHelper.size18.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height(0.5.h),
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
                            fontFamily: boldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Accept / Booked button
                (lead['lead_status'] == 'booked')
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
            height(1.h),

            Divider(
              color: ColorsForApp.grey,
            ),
            height(1.h),

            /// ---------------- Route Info ----------------
            Row(
              children: [
                Icon(Icons.navigation_outlined, color: ColorsForApp.green),
                width(0.5.w),

                /// From
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lead['from'],
                        style: TextHelper.size18.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorsForApp.blackColor,
                          fontFamily: semiBoldFont,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      width(1.w),
                      const Icon(Icons.arrow_right_alt, color: Colors.black),
                      width(1.w),

                      /// To
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
                  "₹ ${lead['price']}",
                  style: TextHelper.size20.copyWith(
                    color: ColorsForApp.green,
                    fontFamily: boldFont,
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
                      width(1.w),
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
              ],
            ),
            height(1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    width(1.w),
                    Text(
                      lead['distance'] ?? " - ",
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// ---------------- Date & Time ----------------
            Row(
              children: [
                /// Date
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: ColorsForApp.blackColor),
                    width(1.w),
                    Text(
                      lead['date'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),

                /// Time
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: ColorsForApp.blackColor),
                    width(1.w),
                    Text(
                      lead['time'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// ---------------- Phone ----------------
            // Row(
            //   children: [
            //     Icon(Icons.phone, size: 16, color: ColorsForApp.blackColor),
            //     const SizedBox(width: 6),
            //     Text(
            //       lead['phone'],
            //       style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
            //     ),
            //   ],
            // ),
            Visibility(
              visible: (lead['lead_status'] == 'booked') ? false : true,
              child: Row(
                children: [
                  // WhatsApp
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsForApp.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: ColorsForApp.whiteColor,
                    ),
                    label: Text(
                      "WhatsApp",
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.whiteColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                    onPressed: () => onWhatsApp?.call(lead['phone']),
                  ),
                  const SizedBox(width: 8),
                  // Call
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsForApp.subTitleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      Icons.call_outlined,
                      color: ColorsForApp.whiteColor,
                    ),
                    label: Text(
                      "Call",
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.whiteColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                    onPressed: () => onCall?.call(lead['phone']),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
