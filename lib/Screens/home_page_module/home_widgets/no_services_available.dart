import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoServicesAvailable extends StatelessWidget {
  final String message;
  final String details;
  final Widget? icon;
  const NoServicesAvailable({
    Key? key,
    this.message = "No Services Available",
    this.details = "We couldn't find any services in your area right now.",
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ??
              Icon(
                Icons.hotel,
                size: 60.sp,
                color: Colors.deepOrangeAccent,
              ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            details,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
