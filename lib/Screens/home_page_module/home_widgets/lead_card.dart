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
/// - Added "Booked" watermark for booked leads
/// - Cleaned spacing & responsiveness
/// - Used Expanded/Flexible for layout adjustments
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
    return Stack(
      children: [
        /// ---------------- Card Content ----------------
        Card(
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
                    /// Trip Type
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              lead['trip_type'] == 0
                                  ? "ONEWAY TRIP"
                                  : lead['trip_type'] == 1
                                      ? "RETURN TRIP"
                                      : lead['trip_type'] == 2
                                          ? "RENTED TRIP"
                                          : "OTHER TRIP",
                              style: TextHelper.size18.copyWith(
                                color: ColorsForApp.colorBlackShade,
                                fontFamily: boldFont,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                fontFamily: boldFont,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                height(0.5.h),

                /// ---------------- Name & Accept Button ----------------
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

                    /// Accept button (hidden when booked)
                    if (lead['lead_status'] != 'booked')
                      ElevatedButton(
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

                Divider(color: ColorsForApp.grey),
                height(1.h),

                /// ---------------- Route Info ----------------
                Row(
                  children: [
                    Icon(Icons.navigation_outlined, color: ColorsForApp.green),
                    width(0.5.w),

                    /// From → To
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              lead['from'],
                              style: TextHelper.size18.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorsForApp.blackColor,
                                fontFamily: semiBoldFont,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          width(1.w),
                          const Icon(Icons.arrow_right_alt, color: Colors.black),
                          width(1.w),
                          Flexible(
                            child: Text(
                              lead['to'],
                              style: TextHelper.size18.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorsForApp.blackColor,
                                fontFamily: semiBoldFont,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
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

                /// ---------------- Car Info ----------------
                Row(
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
                height(1.h),

                /// ---------------- Distance ----------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    width(1.w),
                    Expanded(
                      child: Text(
                        lead['distance'] ?? " - ",
                        style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                      ),
                    ),
                  ],
                ),
                height(1.h),

                /// ---------------- Date & Time ----------------
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: ColorsForApp.blackColor),
                    width(1.w),
                    Text(
                      lead['date'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.access_time, size: 16, color: ColorsForApp.blackColor),
                    width(1.w),
                    Text(
                      lead['time'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// ---------------- WhatsApp / Call ----------------
                Visibility(
                  visible: (lead['lead_status'] != 'booked'),
                  child: Row(
                    children: [
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
        ),

        /// ---------------- Watermark ----------------
        if (lead['lead_status'] == 'booked')
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Transform.rotate(
                  angle: -0.5, // tilt
                  child: Text(
                    "BOOKED",
                    style: TextStyle(
                      fontSize: 40.sp, // responsive text
                      color: Colors.red.withOpacity(0.3),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
