import 'package:QuickCab/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
        Lottie.asset(
          Assets.animationNoDataFound,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          repeat: true, // loop animation
          animate: true, // auto-play
        ),
        SizedBox(height: 20),
        Text(title, textAlign: TextAlign.center, style: TextHelper.h7.copyWith(fontFamily: boldFont, color: ColorsForApp.blackColor)),
        SizedBox(height: 10),
        Text(subTitle,
            textAlign: TextAlign.center, style: TextHelper.size18.copyWith(fontFamily: regularFont, color: ColorsForApp.blackColor)),
        SizedBox(height: 20),
      ],
    );
  }
}
