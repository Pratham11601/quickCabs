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
    final pickup   = (lead['from'] ?? '').toString();
    final drop     = (lead['to'] ?? '').toString();
    final price    = "₹${lead['price'] ?? ''}";
    final distance = (lead['distance'] ?? '').toString();
    final eta      = (lead['time'] ?? '').toString();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffFFE4DA), width: 0.4.w),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: const [
          BoxShadow(blurRadius: 8, offset: Offset(0, 0.3), color: Color(0x14000000)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pickup + Price
          Row(
            children: [
              Container(height: 1.3.h, width: 1.3.h,
                  decoration: const BoxDecoration(color: Color(0xFF1BB56E), shape: BoxShape.circle)),
              SizedBox(width: 2.w),
              Expanded(child: Text(
                pickup,
                style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w700, color: const Color(0xff1C1C1E)),
              )),
              Text(
                price,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: const Color(0xffFF6A3D)),
              ),
            ],
          ),

          SizedBox(height: 0.8.h),

          // Drop + Distance
          Row(
            children: [
              Container(height: 1.3.h, width: 1.3.h,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
              SizedBox(width: 2.w),
              Expanded(child: Text(
                drop,
                style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w600, color: const Color(0xff1C1C1E)),
              )),
              Text(
                distance,
                style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600, color: const Color(0xff666A6D)),
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          // Rating, ETA, Payment
          Row(
            children: [
              Icon(Icons.star, color: const Color(0xffFFC107), size: 2.h),
              SizedBox(width: 1.w),
              Text("4.8", style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600)),
              SizedBox(width: 3.w),
              Icon(Icons.access_time, color: const Color(0xFF2196F3), size: 2.h),
              SizedBox(width: 1.w),
              Text("ETA: $eta", style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600)),
              SizedBox(width: 3.w),
              Icon(Icons.attach_money, color: const Color(0xff1BB56E), size: 2.h),
              SizedBox(width: 1.w),
              Text("digital", style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600)),
            ],
          ),

          SizedBox(height: 2.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff1C1C1E),
                    backgroundColor: const Color(0xffF8F8F8),
                    side: BorderSide.none,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF6A3D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                  ),
                  child: const Text('Accept Ride'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
