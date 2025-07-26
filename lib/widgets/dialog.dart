import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../widgets/constant_widgets.dart';
import 'custom_button.dart';

class CustomDialog {
  CustomDialog._();

  static SimpleDialog simpleDialog(BuildContext context, {required Widget child}) => SimpleDialog(
        children: [child],
      );

  static AlertDialog yesNoDialog(BuildContext context, {String? title, required String note}) {
    return AlertDialog(
      title: Text(
        title ?? 'Alert',
        style: TextStyle(fontSize: 16.sp),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            note,
            style: TextStyle(fontSize: 14.sp),
          ),
          height(2.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  width: 30.w,
                  borderSide: BorderSide(color: ColorsForApp.primaryColor, width: 1.5),
                  labelStyle: TextStyle(color: ColorsForApp.primaryColor),
                  onPressed: () {
                    Get.back(result: false);
                  },
                  label: 'No',
                ),
              ),
              width(3.w),
              Expanded(
                child: CustomButton(
                  width: 30.w,
                  onPressed: () {
                    Get.back(result: true);
                  },
                  label: 'Yes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Dialog boxes

  static void showCustomDialog({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required List<Color> backgroundColors,
    required String title,
    required String message,
    Function? onClose,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 85.w,
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: backgroundColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 40.sp,
                ),
                height(1.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextHelper.size18(context).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                height(1.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextHelper.size15(context).copyWith(color: Colors.white70),
                ),
                height(3.h),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    if (onClose != null) onClose();
                  },
                  child: Container(
                    width: 50.w,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Close',
                      style: TextHelper.size14(context).copyWith(fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
