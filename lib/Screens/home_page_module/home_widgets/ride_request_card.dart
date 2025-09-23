import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RideRequestCard extends StatefulWidget {
  final Map<String, dynamic> lead;
  final void Function(String phone)? onWhatsApp; // WhatsApp button callback
  final void Function(String phone)? onCall; // Call button callback
  final void Function(int status)? onToggle; // Toggle status callback
  final bool showToggle; // Toggle button visibility

  const RideRequestCard({
    super.key,
    required this.lead,
    this.onWhatsApp,
    this.onCall,
    this.onToggle,
    this.showToggle = true, // default true
  });

  @override
  State<RideRequestCard> createState() => _RideRequestCardState();
}

class _RideRequestCardState extends State<RideRequestCard> {
  late RxInt status;

  @override
  void initState() {
    super.initState();
    status = (widget.lead['status'] as int).obs; // convert int -> RxInt
  }

  @override
  Widget build(BuildContext context) {
    // Use widget.lead safely here
    final car = (widget.lead['car'] ?? '').toString();
    final name = (widget.lead['name'] ?? '').toString();
    final phone = (widget.lead['phone'] ?? '').toString();
    final location = (widget.lead['location'] ?? '').toString();
    final fromDate = (widget.lead['from_date'] ?? '').toString();
    final fromTime = (widget.lead['from_time'] ?? '').toString();
    final toDate = (widget.lead['to_date'] ?? '').toString();
    final toTime = (widget.lead['to_time'] ?? '').toString();

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
          // Header row: Name + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextHelper.size20.copyWith(
                    color: ColorsForApp.primaryDarkColor,
                    fontFamily: semiBoldFont,
                  ),
                ),
              ),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: status.value == 1 ? ColorsForApp.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        status.value == 1 ? "Active" : "Inactive",
                        style: TextHelper.size18.copyWith(
                          color: status.value == 1 ? ColorsForApp.green : Colors.red,
                          fontFamily: boldFont,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 3.w),
                      if (widget.showToggle)
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Switch(
                            value: status.value == 1,
                            activeColor: ColorsForApp.green,
                            inactiveThumbColor: Colors.red,
                            onChanged: (bool value) {
                              final newStatus = value ? 1 : 0;
                              status.value = newStatus;
                              widget.onToggle?.call(newStatus);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Car + Location
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
            ],
          ),
          SizedBox(height: 1.h),
          Row(
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
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // From Date
          Row(
            children: [
              Icon(Icons.calendar_month, color: ColorsForApp.blackColor.withValues(alpha: 0.4), size: 2.h),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  " From: $fromDate, $fromTime",
                  style: TextHelper.size18.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: regularFont,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // To Date
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: ColorsForApp.blackColor.withValues(alpha: 0.4), size: 2.h),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  " To: $toDate, $toTime",
                  style: TextHelper.size18.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: regularFont,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // WhatsApp + Call buttons
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsForApp.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(FontAwesomeIcons.whatsapp, color: ColorsForApp.whiteColor),
                label: Text(
                  "WhatsApp",
                  style: TextHelper.size18.copyWith(
                    color: ColorsForApp.whiteColor,
                    fontFamily: semiBoldFont,
                  ),
                ),
                onPressed: () => widget.onWhatsApp?.call(phone),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsForApp.subTitleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(Icons.call_outlined, color: ColorsForApp.whiteColor),
                label: Text(
                  "Call",
                  style: TextHelper.size18.copyWith(
                    color: ColorsForApp.whiteColor,
                    fontFamily: semiBoldFont,
                  ),
                ),
                onPressed: () => widget.onCall?.call(phone),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
