// Snack bar for showing success message
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'constant_widgets.dart';

class SnackBar {
  SnackBar._();
  static SnackbarController? success({String title = 'Success', String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.log('\x1B[92m[$title] => $message\x1B[0m');
    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.task_alt_outlined,
                color: Colors.white,
              ),
              width(3.w),
              Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(Get.context!).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          messageText: Text(
            message,
            textAlign: TextAlign.left,
            style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          isDismissible: true,
          backgroundColor: Colors.green.shade400,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.only(left: 4.w, top: 1.h, right: 4.w, bottom: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }

// Snack bar for showing pending message
  static SnackbarController? pending({String title = 'Pending', String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.log('\x1B[93m[$title] => $message\x1B[0m');
    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.timelapse_outlined,
                color: Colors.white,
              ),
              width(3.w),
              Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(Get.context!).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          messageText: Text(
            message,
            textAlign: TextAlign.left,
            style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          isDismissible: true,
          backgroundColor: Colors.orange[400]!,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.only(left: 4.w, top: 1.h, right: 4.w, bottom: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }

// Snack bar for showing info message
  static SnackbarController? info({String title = 'Info', String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.log('\x1B[93m[$title] => $message\x1B[0m');
    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              width(3.w),
              Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(Get.context!).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          messageText: Text(
            message,
            textAlign: TextAlign.left,
            style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          isDismissible: true,
          backgroundColor: Colors.grey[400]!,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.only(left: 4.w, top: 1.h, right: 4.w, bottom: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }

// Snack bar for showing error message
  static SnackbarController? error({String title = 'Failure', String? message}) {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
    Get.log('\x1B[91m[$title] => $message\x1B[0m', isError: true);
    if (message != null && message.isNotEmpty) {
      return Get.showSnackbar(
        GetSnackBar(
          titleText: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.gpp_bad_outlined,
                color: Colors.white,
              ),
              width(3.w),
              Text(
                title,
                textAlign: TextAlign.left,
                style: Theme.of(Get.context!).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          messageText: Text(
            message,
            textAlign: TextAlign.left,
            style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          isDismissible: true,
          backgroundColor: Colors.red[400]!,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.only(left: 4.w, top: 1.h, right: 4.w, bottom: 1.5.h),
          borderRadius: 10,
          duration: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 500),
        ),
      );
    }
    return null;
  }
}
