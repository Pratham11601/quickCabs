import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../generated/assets.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  const NoDataFoundScreen({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Assets.iconsNavigation, scale: 4),
        SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.h,
          ),
        ),
        SizedBox(height: 10),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12.h,
          ),
        ),
      ],
    );
  }
}
