import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/service_card_controller.dart';

class EmergencyServiceCard extends StatelessWidget {
  final String title;
  final String location;
  final String serviceType;
  final EmergencyServicesCardController controller = Get.find();

  EmergencyServiceCard({super.key, required this.title, required this.location, required this.serviceType,});

  @override
  Widget build(BuildContext context) {
    Color levelColor = Colors.red;
    return
      Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Location and time row
            Row(
              children: [
                Icon(Icons.location_on, size: 16.5.sp, color: Colors.grey),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Response time row
            Row(
              children: [
                Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                SizedBox(width: 2.w),
                Text(
                  "Response time: ",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 2.2.h),
            // Buttons row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigation action here
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade200, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.navigation),
                    label: Text(
                      "Navigate",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Call Now action here
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      backgroundColor: const Color(0xFFF44336),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    icon: Icon(Icons.call),
                    label: Text(
                      "Call Now",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
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
