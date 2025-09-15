import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../generated/assets.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

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
        // Image.asset(Assets.iconsNavigation, scale: 4),
        SizedBox(height: 20),
        Text(title,
            textAlign: TextAlign.center,
            style: TextHelper.size17.copyWith(
                fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
        SizedBox(height: 10),
        Text(subTitle,
            textAlign: TextAlign.center,
            style: TextHelper.size17.copyWith(
                fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
        SizedBox(height: 20),
      ],
    );
  }
}
