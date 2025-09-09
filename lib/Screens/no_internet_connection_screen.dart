import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../controller/network_controller.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../widgets/constant_widgets.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  final RxBool showShimmer = false.obs;

  NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent back navigation
      child: Scaffold(
        body: Stack(
          children: [
            /// main content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lottie.asset(
                    //   Assets.animationsNoInternetConnection,
                    //   fit: BoxFit.cover,
                    //   height: 30.h,
                    // ),
                    Text(
                      'Whoops!',
                      textAlign: TextAlign.center,
                      style: TextHelper.h2.copyWith(
                        fontFamily: boldFont,
                        color: ColorsForApp.secondaryColor,
                      ),
                    ),
                    height(1.5.h),
                    Text(
                      'No internet connection found.\nTry switching to a different connection or reset your internet.',
                      textAlign: TextAlign.center,
                      style: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                        color: ColorsForApp.blackColor,
                      ),
                    ),
                    height(3.h),
                    GestureDetector(
                      onTap: () async {
                        showShimmer.value = true;

                        await Future.delayed(const Duration(milliseconds: 1200));

                        final networkController = Get.find<NetworkController>();

                        if (networkController.isInternetAvailable.value) {
                          showShimmer.value = false;
                          Get.back(); // close no internet screen
                        } else {
                          showShimmer.value = false;
                          ShowSnackBar.error(
                            title: "No Internet",
                            message: "Still no connection found.",
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 1.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'RETRY',
                          style: TextHelper.size18.copyWith(
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

            /// shimmer overlay
            Obx(
              () => showShimmer.value
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 100.h,
                        width: 100.w,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
