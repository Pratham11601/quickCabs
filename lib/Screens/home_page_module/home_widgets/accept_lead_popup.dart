import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sizer/sizer.dart';
import '../controller/accept_lead_popup_controller.dart';


class AcceptLeadOtpPopup extends StatelessWidget {
  final String sharedBy;
  final String route;
  final int fare;

  AcceptLeadOtpPopup({
    Key? key,
    required this.sharedBy,
    required this.route,
    required this.fare,
  }) : super(key: key);

  final AcceptLeadOtpPopupController controller =
  Get.put(AcceptLeadOtpPopupController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(4.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 5.5.w,
                    backgroundColor: Colors.orange.shade50,
                    child: Icon(Icons.check, color: Colors.orange, size: 8.w),
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Accept Lead",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Enter OTP to confirm",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, size: 6.w),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Lead Info Container
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
                    _detailRow(
                      "Fare:",
                      "₹$fare",
                      valueStyle: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Enter 4-digit OTP",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              Text(
                "OTP sent to your registered mobile number",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
              SizedBox(height: 2.h),

              Obx(() => OTPTextField(
                length: 4,
                width: 80.w,
                fieldWidth: 12.w,
                style: TextStyle(fontSize: 17.sp),
                textFieldAlignment: MainAxisAlignment.center,
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
              )),

              SizedBox(height: 2.h),
              Obx(() {
                if (controller.isCountdownActive.value) {
                  return Text(
                    "Resend OTP in ${controller.timerSeconds.value}s",
                    style: TextStyle(color: Colors.orange, fontSize: 14.sp, fontWeight: FontWeight.w600),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => controller.resendOtp(),
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  );
                }
              }),

              SizedBox(height: 3.h),
              Obx(() {
                if (controller.showError.value) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Text(
                      "Incorrect OTP Please try again.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  );
                } else if (controller.showSuccess.value) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green, size: 8.w),
                        SizedBox(width: 2.w),
                        Text(
                          "Lead Accepted!",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      onPressed:
                      controller.otpText.value.length == 4
                          ? () =>
                          controller.handleAcceptLead(context)
                          : null,
                      child: Text(
                        "Accept Lead",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500)),
          Spacer(),
          Text(value,
              style: valueStyle ??
                  TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
