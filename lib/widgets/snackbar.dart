// Snack bar for showing messages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import 'constant_widgets.dart';

class ShowSnackBar {
  ShowSnackBar._();

  // ✅ Success Snackbar
  static SnackbarController? success({String title = 'Success', String? message}) {
    if (Get.isSnackbarOpen) Get.back();
    Get.log('\x1B[92m[$title] => $message\x1B[0m');

    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            children: [
              Icon(Icons.task_alt_outlined, color: ColorsForApp.whiteColor),
              width(3.w),
              Text(
                title,
                style: TextHelper.size20.copyWith(
                  fontFamily: boldFont,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ],
          ),
          messageText: Text(
            message,
            style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: regularFont),
          ),
          backgroundColor: Colors.green.shade400,
          isDismissible: true,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }

  // ✅ Pending Snackbar
  static SnackbarController? pending({String title = 'Pending', String? message}) {
    if (Get.isSnackbarOpen) Get.back();
    Get.log('\x1B[93m[$title] => $message\x1B[0m');

    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            children: [
              Icon(Icons.timelapse_outlined, color: ColorsForApp.whiteColor),
              width(3.w),
              Text(
                title,
                style: TextHelper.size20.copyWith(
                  fontFamily: boldFont,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ],
          ),
          messageText: Text(
            message,
            style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: regularFont),
          ),
          backgroundColor: Colors.orange[400]!,
          isDismissible: true,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }

  // ✅ Info Snackbar
  static SnackbarController? info({String title = 'Info', String? message}) {
    if (Get.isSnackbarOpen) Get.back();
    Get.log('\x1B[94m[$title] => $message\x1B[0m');

    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: ColorsForApp.whiteColor),
              width(3.w),
              Text(
                title,
                style: TextHelper.size20.copyWith(
                  fontFamily: boldFont,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ],
          ),
          messageText: Text(
            message,
            style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: regularFont),
          ),
          backgroundColor: ColorsForApp.colorBlackShade,
          isDismissible: true,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }

  // ✅ Error Snackbar
  static SnackbarController? error({String title = 'Failure', String? message}) {
    if (Get.isSnackbarOpen) Get.back();
    Get.log('\x1B[91m[$title] => $message\x1B[0m', isError: true);

    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            children: [
              Icon(Icons.gpp_bad_outlined, color: ColorsForApp.whiteColor),
              width(3.w),
              Text(
                title,
                style: TextHelper.size20.copyWith(
                  fontFamily: boldFont,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ],
          ),
          messageText: Text(
            message,
            style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: regularFont),
          ),
          backgroundColor: Colors.red[400]!,
          isDismissible: true,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }
}
