import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/constant_widgets.dart';

class LeadCard extends StatelessWidget {
  final Map<String, dynamic> lead;

  final VoidCallback? onAccept;
  final void Function(String phone)? onWhatsApp;
  final void Function(String phone)? onCall;
  final VoidCallback? onShare;

  // 👇 Added new callbacks for subscription checks
  final Future<bool> Function()? onCheckSubscription;
  final VoidCallback? onSubscriptionRequired;

  const LeadCard({
    super.key,
    required this.lead,
    this.onAccept,
    this.onWhatsApp,
    this.onCall,
    this.onShare,
    this.onCheckSubscription,
    this.onSubscriptionRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(2),
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
                      child: Text(
                        _getTripType(lead['trip_type']),
                        style: TextHelper.size18.copyWith(
                          color: ColorsForApp.colorBlackShade,
                          fontFamily: boldFont,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Booking ID
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
                    /// Name
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
                            child: Icon(Icons.handshake, color: ColorsForApp.primaryColor, size: 22),
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
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Accept button
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
                _buildRouteInfo(),
                const SizedBox(height: 6),

                /// ---------------- Car Info ----------------
                _buildCarInfo(),
                height(1.h),

                /// ---------------- Distance ----------------
                _buildDistanceInfo(),
                height(1.h),

                /// ---------------- Toll Tax & Rental Duration ----------------
                _buildTollInfo(),
                height(1.h),

                /// ---------------- Toll Tax & Rental Duration ----------------
                _buildCarrierInfo(),
                height(1.h),

                /// ---------------- Date & Time ----------------
                _buildDateTime(),
                height(1.h),

                /// ---------------- Booked By ----------------
                if (lead['lead_status'] == 'booked')
                  Text(
                    "Booked By - ${_getBookedBy(lead)}",
                    style: TextHelper.size18.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorsForApp.blackColor,
                      fontFamily: semiBoldFont,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                height(1.h),

                /// ---------------- WhatsApp / Call / Share ----------------
                if (lead['lead_status'] != 'booked')
                  Row(
                    children: [
                      _buildWhatsAppButton(),
                      const SizedBox(width: 8),
                      _buildCallButton(),
                      const Spacer(),
                      if ((lead['userId']) == (lead['vendor_id']))
                        Container(
                          decoration: BoxDecoration(
                            color: ColorsForApp.primaryDarkColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            onPressed: onShare,
                            icon: const Icon(Icons.share_outlined, color: Colors.white),
                            tooltip: "Share Lead",
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),

        /// ---------------- BOOKED Ribbon ----------------
        if (lead['lead_status'] == 'booked')
          Positioned(
            top: 18,
            left: -28,
            child: Transform.rotate(
              angle: -0.785,
              child: Container(
                width: 120,
                color: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(
                    "BOOKED",
                    style: TextHelper.size17.copyWith(
                      color: Colors.white,
                      fontFamily: boldFont,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 🔹 Helper methods for cleaner structure

  String _getTripType(int? type) {
    switch (type) {
      case 0:
        return "ONEWAY TRIP";
      case 1:
        return "RETURN TRIP";
      case 2:
        return "RENTED TRIP";
      default:
        return "OTHER TRIP";
    }
  }

  /*String _getBookedBy(Map<String, dynamic> lead) {
    final acceptedBy = lead['acceptedBy'];
    final acceptedByFullname = lead['acceptedBy_fullname'];
    if (acceptedByFullname is String && acceptedByFullname.trim().isNotEmpty) {
      return acceptedByFullname;
    }
    if (acceptedBy is Map && acceptedBy['fullname'] != null) {
      return acceptedBy['fullname'];
    }
    return 'NA';
  }*/

  String _getBookedBy(Map<String, dynamic> lead) {
    final acceptedByFullname = lead['acceptedBy_fullname'];
    final acceptedByPhone = lead['acceptedBy_phone'];
    final acceptedBy = lead['acceptedBy']; // fallback for older structure

    String? name;
    String? phone;

    // ✅ Direct fields (new API)
    if (acceptedByFullname is String && acceptedByFullname.trim().isNotEmpty) {
      name = acceptedByFullname.trim();
    }
    if (acceptedByPhone is String && acceptedByPhone.trim().isNotEmpty) {
      phone = acceptedByPhone.trim();
    }

    // ✅ Fallback: old nested "acceptedBy" map
    if (name == null && acceptedBy is Map && acceptedBy['fullname'] != null) {
      name = acceptedBy['fullname'].toString().trim();
    }
    if (phone == null && acceptedBy is Map && acceptedBy['phone'] != null) {
      phone = acceptedBy['phone'].toString().trim();
    }

    // ✅ Combine smartly
    if (name != null && phone != null) {
      return "$name ($phone)";
    } else if (name != null) {
      return name;
    } else if (phone != null) {
      return phone;
    }

    return 'NA';
  }

  Widget _buildRouteInfo() => Row(
        children: [
          Icon(Icons.navigation_outlined, size: 16, color: ColorsForApp.green),
          width(1.w),
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                width(1.w),
                const Icon(Icons.arrow_right_alt, size: 16, color: Colors.black),
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
                  ),
                ),
              ],
            ),
          ),
          Text(
            "₹ ${lead['price']}",
            style: TextHelper.size20.copyWith(
              color: ColorsForApp.green,
              fontFamily: boldFont,
            ),
          ),
        ],
      );

  Widget _buildCarInfo() => Row(
        children: [
          const Icon(Icons.directions_car_outlined, size: 16, color: Colors.red),
          width(1.w),
          Expanded(
            child: Text(
              lead['car'],
              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );

  Widget _buildDistanceInfo() => Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.red),
              width(1.w),
              Expanded(
                child: Text(
                  "From - ${lead['fromDistance'] ?? '-'}",
                  style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                ),
              ),
            ],
          ),
          height(1.h),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.red),
              width(1.w),
              Expanded(
                child: Text(
                  "To - ${lead['distance'] ?? '-'}",
                  style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildTollInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.toll_rounded, size: 16, color: ColorsForApp.blackColor),
              width(1.w),
              Expanded(
                child: Text(
                  "Toll Tax - ${lead['toll_tax'] ?? '-'}",
                  style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                ),
              ),
            ],
          ),
          if ((lead['trip_type'] ?? -1) == 2) ...[
            height(1.h),
            Row(
              children: [
                Icon(Icons.timelapse, size: 16, color: ColorsForApp.blackColor),
                width(1.w),
                Expanded(
                  child: Text(
                    "Rental Duration - ${lead['rental_duration'] ?? '-'}",
                    style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                  ),
                ),
              ],
            ),
          ],
        ],
      );

  Widget _buildCarrierInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 16, color: ColorsForApp.blackColor),
              width(1.w),
              Expanded(
                child: Text(
                  "Carrier - ${lead['carrier_type'] ?? '-'}",
                  style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                ),
              ),
            ],
          ),
          height(1.h),
          Row(
            children: [
              Icon(Icons.local_gas_station_outlined, size: 16, color: ColorsForApp.blackColor),
              width(1.w),
              Expanded(
                child: Text(
                  "Fuel Type - ${lead['fuel_type'] ?? '-'}",
                  style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildDateTime() {
    if (lead['trip_type'] == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, size: 16, color: ColorsForApp.blackColor),
              width(1.w),
              Expanded(
                child: Text(
                  "Start Date - ${lead['start_date'] ?? '-'} |",
                  style: TextHelper.size18,
                  overflow: TextOverflow.ellipsis, // 👈 Prevents overflow
                ),
              ),
              width(0.5.w),
              Icon(Icons.access_time, size: 16, color: ColorsForApp.blackColor),
              width(1.w),
              Flexible(
                child: Text(
                  "Pick up Time - ${lead['time'] ?? '-'}",
                  style: TextHelper.size18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          height(1.h),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, size: 16, color: ColorsForApp.blackColor),
              width(1.w),
              Text("End Date - ${lead['end_date'] ?? '-'}", style: TextHelper.size18),
            ],
          ),
          height(1.h),
          Row(
            children: [
              Icon(Icons.keyboard_return_outlined, size: 16, color: ColorsForApp.blackColor),
              width(1.w),
              Text("Return Trip Days - ${lead['days'] ?? '-'}", style: TextHelper.size18),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.calendar_month_outlined, size: 16, color: ColorsForApp.blackColor),
          width(1.w),
          Text(lead['date'] ?? '-', style: TextHelper.size18),
          const SizedBox(width: 8),
          Icon(Icons.access_time, size: 16, color: ColorsForApp.blackColor),
          width(1.w),
          Text(lead['time'] ?? '-', style: TextHelper.size18),
        ],
      );
    }
  }

  Widget _buildWhatsAppButton() => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsForApp.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(FontAwesomeIcons.whatsapp, color: ColorsForApp.whiteColor),
        label: Text(
          "WhatsApp",
          style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont),
        ),
        onPressed: () async {
          /*if (onCheckSubscription != null) {
            final isSubscribed = await onCheckSubscription!();
            if (isSubscribed) {
              onWhatsApp?.call(lead['phone']);
            } else {
              onSubscriptionRequired?.call();
            }
          } else {
            onWhatsApp?.call(lead['phone']);
          }*/

          onWhatsApp?.call(lead['phone']);
        },
      );

  Widget _buildCallButton() => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsForApp.subTitleColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(Icons.call_outlined, color: ColorsForApp.whiteColor),
        label: Text(
          "Call",
          style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont),
        ),
        onPressed: () async {
          /*if (onCheckSubscription != null) {
            final isSubscribed = await onCheckSubscription!();
            if (isSubscribed) {
              onCall?.call(lead['phone']);
            } else {
              onSubscriptionRequired?.call();
            }
          } else {
            onCall?.call(lead['phone']);
          }*/
          onCall?.call(lead['phone']);
        },
      );
}
