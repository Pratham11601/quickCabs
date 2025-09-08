  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuickCab/utils/config.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../widgets/constant_widgets.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  final RxBool showShimmer = false.obs;
  NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lottie.asset(
                  //   Assets.animationsNoInternetConnection,
                  //   fit: BoxFit.cover,
                  // ),
                  height(3.h),
                  Text(
                    'Whoops!',
                    textAlign: TextAlign.center,
                    style: TextHelper.h2.copyWith(
                      fontFamily: boldFont,
                      color: ColorsForApp.secondaryColor,
                    ),
                  ),
                  height(1.h),
                  Text(
                    'No internet connection found.\nTry switching to a different connection or reset your internet.',
                    textAlign: TextAlign.center,
                    style: TextHelper.size16.copyWith(
                      fontFamily: mediumFont,
                    ),
                  ),
                  height(2.h),
                  GestureDetector(
                    onTap: () async {
                      showShimmer.value = true;
                      if (Config.isInternetAvailable.value == true) {
                        showShimmer.value = false;
                       Get.back();
                      } else {
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          showShimmer.value = false;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.2.h),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'RETRY',
                        style: TextHelper.size16.copyWith(
                          fontFamily: boldFont,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Shimmer effect covering the entire screen
          Obx(
            () => showShimmer.value && !Config.isInternetAvailable.value
                ? Shimmer.fromColors(
                    baseColor: Colors.white10,
                    highlightColor: Colors.white70,
                    child: Container(
                      height: 100.h,
                      width: 100.w,
                      color: ColorsForApp.whiteColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
