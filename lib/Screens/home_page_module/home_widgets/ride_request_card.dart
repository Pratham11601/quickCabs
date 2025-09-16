import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class RideRequestCard extends StatelessWidget {
  final Map<String, dynamic> lead;
  final void Function(String phone)? onWhatsApp; // WhatsApp button callback
  final void Function(String phone)? onCall; //

  const RideRequestCard({
    super.key,
    required this.lead,
    this.onWhatsApp,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final car = (lead['car'] ?? '').toString();
    final name = (lead['name'] ?? '').toString();
    final phone = (lead['phone'] ?? '').toString();
    final location = (lead['location'] ?? '').toString();
    final fromDate = (lead['from_date'] ?? '').toString();
    final fromTime = (lead['from_time'] ?? '').toString();
    final toDate = (lead['to_date'] ?? '').toString();
    final toTime = (lead['to_time'] ?? '').toString();
    final status = lead['status'] ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: ColorsForApp.subTitleColor.withValues(alpha: 0.2),
          width: 0.4.w,
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header row: Car + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextHelper.size20.copyWith(
                  color: ColorsForApp.primaryDarkColor,
                  fontFamily: semiBoldFont,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: status == 1 ? ColorsForApp.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  status == 1 ? "Active" : "Inactive",
                  style: TextHelper.size18.copyWith(
                    color: status == 1 ? ColorsForApp.green : Colors.red,
                    fontFamily: boldFont,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          // Car + location
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.directions_car_outlined, color: ColorsForApp.colorBlue),
                    SizedBox(width: 1.w),
                    Text(
                      car,
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                  ],
                ),
              ),

              // Location
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: ColorsForApp.red),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        location,
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
          SizedBox(
            height: 1.h,
          ),
          // Dates
          Row(
            children: [
              Icon(Icons.calendar_today, color: ColorsForApp.blackColor.withValues(alpha: 0.4), size: 2.h),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  "From: $fromDate | $fromTime",
                  style: TextHelper.size18.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: regularFont,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(Icons.calendar_today, color: ColorsForApp.blackColor.withValues(alpha: 0.4), size: 2.h),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  "To:   $toDate | $toTime",
                  style: TextHelper.size18.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: regularFont,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ///////////////// Phone ///////////////////
          Row(
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
          )
        ],
      ),
    );
  }
}
