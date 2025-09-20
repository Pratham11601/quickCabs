import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class DocumentCardShimmer extends StatelessWidget {
  const DocumentCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.4.w,
          ),
        ),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
            SizedBox(width: 4.w),

            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2.5.h,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 40.w,
                    height: 2.h,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
