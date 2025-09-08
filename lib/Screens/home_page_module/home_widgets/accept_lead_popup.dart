import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sizer/sizer.dart';

import '../controller/accept_lead_popup_controller.dart';

/// AcceptLeadOtpPopup
/// ------------------
/// A popup dialog for confirming lead acceptance with OTP validation.
/// Features:
/// - Displays lead details (sharedBy, route, fare)
/// - OTP input with error/success state
/// - Resend OTP countdown
/// - Cancel / Accept Lead actions
class AcceptLeadOtpPopup extends StatelessWidget {
  final String sharedBy;
  final String route;
  final int fare;
  final int leadId;

  const AcceptLeadOtpPopup({
    super.key,
    required this.sharedBy,
    required this.route,
    required this.fare,
    required this.leadId,
  });

  @override
  Widget build(BuildContext context) {
    // Inject controller with the leadId
    final AcceptLeadOtpPopupController controller = Get.put(AcceptLeadOtpPopupController(leadId: leadId));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ---------------- Header ----------------
              Row(
                children: [
                  CircleAvatar(
                    radius: 5.5.w,
                    backgroundColor: ColorsForApp.green,
                    child: Icon(Icons.check, color: ColorsForApp.whiteColor, size: 8.w),
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Accept Lead", style: TextHelper.h7.copyWith(fontFamily: boldFont, color: ColorsForApp.blackColor)),
                      Text("Enter OTP to confirm",
                          style: TextHelper.size17.copyWith(fontFamily: regularFont, color: ColorsForApp.subtitle)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              /// ---------------- Lead Info ----------------
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    _detailRow("Shared by:", sharedBy),
                    _detailRow("Route:", route),
                    _detailRow("Fare:", "₹ ${fare.toStringAsFixed(0)}",
                        valueStyle: TextHelper.size18.copyWith(color: ColorsForApp.green, fontFamily: semiBoldFont)),
                  ],
                ),
              ),
              SizedBox(height: 1.h),

              /// ---------------- OTP Section ----------------
              Text(
                "Enter 4-digit OTP",
                style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
              ),
              SizedBox(height: 0.5.h),
              Text(
                "OTP sent to your registered mobile number",
                style: TextHelper.size16.copyWith(color: ColorsForApp.subtitle, fontFamily: regularFont),
              ),
              SizedBox(height: 2.h),

              /// OTP Input Field
              Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85, // Responsive width (85% of screen)
                  child: OTPTextField(
                    length: 4,
                    fieldWidth: 12.w,
                    style: TextStyle(fontSize: 17.sp),
                    textFieldAlignment: MainAxisAlignment.spaceEvenly,
                    fieldStyle: FieldStyle.box,
                    otpFieldStyle: OtpFieldStyle(
                      borderColor: controller.showError.value
                          ? Colors.red
                          : controller.showSuccess.value
                              ? Colors.green
                              : Colors.orange,
                      focusBorderColor: Colors.orange,
                      enabledBorderColor: Colors.grey.shade300,
                    ),
                    outlineBorderRadius: 2.w,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.otpText.value = value;
                      controller.showError.value = false;
                      controller.showSuccess.value = false;
                    },
                    onCompleted: (value) {
                      controller.otpText.value = value;
                    },
                  ),
                ),
              ),

              SizedBox(height: 1.5.h),

              /// Resend OTP or Countdown
              Obx(() {
                if (controller.isCountdownActive.value) {
                  return Text("Resend OTP in ${controller.timerSeconds.value}s",
                      style: TextHelper.size18.copyWith(color: ColorsForApp.primaryDarkColor, fontFamily: semiBoldFont));
                } else {
                  return GestureDetector(
                    onTap: controller.resendOtp,
                    child: Text("Resend OTP",
                        style: TextHelper.size18.copyWith(
                            color: ColorsForApp.primaryDarkColor, fontFamily: semiBoldFont, decoration: TextDecoration.underline)),
                  );
                }
              }),
              SizedBox(height: 1.5.h),

              /// OTP Status Message
              Obx(() {
                if (controller.showError.value) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Text("Incorrect OTP. Please try again.",
                        style: TextHelper.size17.copyWith(color: ColorsForApp.red, fontFamily: boldFont)),
                  );
                } else if (controller.showSuccess.value) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 8.w),
                        SizedBox(width: 2.w),
                        Text("Lead Accepted!", style: TextHelper.size17.copyWith(color: ColorsForApp.green, fontFamily: boldFont))
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              SizedBox(height: 1.5.h),

              /// ---------------- Action Buttons ----------------
              Row(
                children: [
                  /// Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h), // matched with Accept button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        side: BorderSide(color: Colors.grey.shade400, width: 1), // proper border
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancel",
                        style: TextHelper.size18.copyWith(
                          color: ColorsForApp.blackColor,
                          fontFamily: semiBoldFont,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),

                  /// Accept Lead Button
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        onPressed: controller.otpText.value.length == 4 ? () => controller.handleAcceptLead(context) : null,
                        child: Text(
                          "Accept Lead",
                          style: TextHelper.size18.copyWith(
                            fontFamily: semiBoldFont,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      ),
                    ), // only observe enabled/disabled state
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable row widget for displaying lead details
  Widget _detailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.3.h),
      child: Row(
        children: [
          Text(label, style: TextHelper.size18.copyWith(color: ColorsForApp.subtitle, fontFamily: semiBoldFont)),
          const Spacer(),
          Text(value, style: valueStyle ?? TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
        ],
      ),
    );
  }
}
