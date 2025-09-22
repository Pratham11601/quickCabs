import 'package:QuickCab/Screens/login_signup_module/controller/forgot_password_controller.dart';
import 'package:QuickCab/Screens/login_signup_module/controller/signup_controller.dart';
import 'package:QuickCab/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/common_elevated_button.dart';
import '../../../../widgets/common_widgets.dart';

class OtpVerifyContainer extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onChangeNumber;

  const OtpVerifyContainer({
    super.key,
    required this.phoneNumber,
    required this.onChangeNumber,
  });

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.find();
    final ForgotPasswordController forgotPasswordController = Get.find();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      padding: const EdgeInsets.all(20),
      decoration: boxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_user,
              color: ColorsForApp.primaryColor, size: 50),
          const SizedBox(height: 15),

          /// Title
          Text(
            "Verify OTP",
            style: TextHelper.h4.copyWith(
                color: ColorsForApp.headline, fontFamily: semiBoldFont),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter the 4-digit code sent to",
            style: TextHelper.size18.copyWith(color: ColorsForApp.headline),
          ),
          const SizedBox(height: 4),
          Text(
            "+91 $phoneNumber",
            style: TextHelper.size18.copyWith(
                color: ColorsForApp.headline, fontFamily: semiBoldFont),
          ),
          const SizedBox(height: 20),

          /// OTP Input
          Obx(() {
            final isSignupFlow = signupController.canSubmit;
            final isForgotFlow = forgotPasswordController.canForgot;

            return OutlinedField(
              isFocused: isSignupFlow
                  ? signupController.isOtpFocused.value
                  : forgotPasswordController.isOtpFocused.value,
              child: TextFormField(
                controller: isSignupFlow
                    ? signupController.otpController
                    : forgotPasswordController.otpController,
                focusNode: isSignupFlow
                    ? signupController.otpFocusNode
                    : forgotPasswordController.otpFocusNode,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: TextHelper.h5.copyWith(
                  color: ColorsForApp.blackColor,
                  letterSpacing: 2,
                  fontFamily: semiBoldFont,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: "Enter Your OTP",
                  hintStyle: TextHelper.size18
                      .copyWith(color: Colors.grey, fontFamily: regularFont),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            );
          }),
          const SizedBox(height: 15),

          /// Verify Button
          Obx(() => CommonElevatedButton(
                isLoading: signupController.isLoading.value ||
                    forgotPasswordController.isLoading.value,
                text: 'Verify & Continue',
                icon: Icons.arrow_right_alt_rounded,
                onPressed: () async {
                  // 🔹 Signup Flow
                  if (signupController.canSubmit) {
                    final result =
                        await signupController.verifyRegistrationOtp();
                    if (result) {
                      Get.toNamed(Routes.REGISTRATION_DETAILS_SCREEN);
                    }
                  }

                  // 🔹 Forgot Password Flow
                  else if (forgotPasswordController.canForgot) {
                    final result =
                        await forgotPasswordController.verifyForgotOtp();
                    if (result) {
                      forgotPasswordController.currentStep.value =
                          2; // go to Change Password
                    }
                  }
                },
              )),
          const SizedBox(height: 15),

          /// Change Mobile Number
          GestureDetector(
            onTap: onChangeNumber,
            child: Text(
              "Change mobile number",
              style: TextHelper.size19.copyWith(
                color: ColorsForApp.primaryColor,
                fontFamily: semiBoldFont,
              ),
            ),
          ),
          const SizedBox(height: 15),

          /// Resend OTP or Countdown
          Obx(() {
            final signupTimer = signupController.resendTimer.value;
            final forgotTimer = forgotPasswordController.secondsRemaining.value;

            if (signupController.canSubmit && signupTimer > 0) {
              return _timerWidget(signupTimer);
            } else if (forgotPasswordController.canForgot && forgotTimer > 0) {
              return _timerWidget(forgotTimer);
            } else {
              return InkWell(
                onTap: () async {
                  // Signup resend
                  if (signupController.canSubmit) {
                    signupController.showOtpScreen.value =
                        await signupController.generateRegistrationOtp();
                    if (signupController.showOtpScreen.value) {
                      signupController.startTimer();
                    }
                  }

                  // Forgot password resend
                  if (forgotPasswordController.canForgot) {
                    await forgotPasswordController.generateForgotOtp();
                    forgotPasswordController.startTimer();
                    // call your forgot password resend API here
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh,
                        size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 5),
                    Text(
                      "Resend OTP",
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  /// Timer Widget
  Widget _timerWidget(int seconds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.access_time, size: 16),
        const SizedBox(width: 5),
        Text(
          "Resend OTP in ${seconds}s",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
