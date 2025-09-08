import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RideRequestCard extends StatelessWidget {
  final Map<String, dynamic> lead;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const RideRequestCard({
    super.key,
    required this.lead,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final pickup = (lead['from'] ?? '').toString();
    final drop = (lead['to'] ?? '').toString();
    final price = "₹${lead['price'] ?? ''}";
    final distance = (lead['distance'] ?? '').toString();
    final eta = (lead['time'] ?? '').toString();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ColorsForApp.subTitleColor.withValues(alpha: 0.2), width: 0.4.w),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pickup + Price
          Row(
            children: [
              Container(height: 1.3.h, width: 1.3.h, decoration: const BoxDecoration(color: Color(0xFF1BB56E), shape: BoxShape.circle)),
              SizedBox(width: 2.w),
              Expanded(
                  child: Text(
                pickup,
                style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
              )),
              Text(
                price,
                style: TextHelper.size20.copyWith(color: ColorsForApp.green, fontFamily: boldFont),
              ),
            ],
          ),

          SizedBox(height: 0.8.h),

          // Drop + Distance
          Row(
            children: [
              Container(height: 1.3.h, width: 1.3.h, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
              SizedBox(width: 2.w),
              Expanded(
                  child: Text(
                drop,
                style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
              )),
              Text(
                distance,
                style: TextHelper.size17.copyWith(color: ColorsForApp.subtitle, fontFamily: semiBoldFont),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Rating, ETA, Payment
          Row(
            children: [
              Icon(Icons.star, color: ColorsForApp.yellow, size: 2.h),
              SizedBox(width: 0.5.w),
              Text("4.8", style: TextHelper.size17.copyWith(color: ColorsForApp.subtitle, fontFamily: semiBoldFont)),
              SizedBox(width: 3.w),
              Icon(Icons.access_time, color: ColorsForApp.colorBlue, size: 2.h),
              SizedBox(width: 0.5.w),
              Text("ETA: $eta", style: TextHelper.size17.copyWith(color: ColorsForApp.subtitle, fontFamily: semiBoldFont)),
              SizedBox(width: 3.w),
              Icon(Icons.currency_rupee, color: ColorsForApp.green, size: 1.8.h),
              SizedBox(width: 0.5.w),
              Text("digital", style: TextHelper.size17.copyWith(color: ColorsForApp.subtitle, fontFamily: semiBoldFont)),
            ],
          ),

          // SizedBox(height: 2.h),

          // Buttons
          // Row(
          //   children: [
          //     Expanded(
          //       child: OutlinedButton(
          //         onPressed: onDecline,
          //         style: OutlinedButton.styleFrom(
          //           foregroundColor: const Color(0xff1C1C1E),
          //           backgroundColor: const Color(0xffF8F8F8),
          //           side: BorderSide.none,
          //           padding: EdgeInsets.symmetric(vertical: 1.8.h),
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          //           textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
          //         ),
          //         child: const Text('Decline'),
          //       ),
          //     ),
          //     SizedBox(width: 3.w),
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: onAccept,
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: const Color(0xffFF6A3D),
          //           foregroundColor: Colors.white,
          //           elevation: 0,
          //           padding: EdgeInsets.symmetric(vertical: 1.8.h),
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          //           textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
          //         ),
          //         child: const Text('Accept Ride'),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
