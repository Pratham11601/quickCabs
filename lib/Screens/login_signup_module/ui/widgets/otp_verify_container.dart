import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/login_signup_module/controller/signup_controller.dart';
import 'package:own_idea/routes/routes.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/common_elevated_button.dart';
import '../../../../widgets/common_widgets.dart';

class OtpVerifyContainer extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onChangeNumber;

  const OtpVerifyContainer(
      {super.key, required this.phoneNumber, required this.onChangeNumber});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.find();

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
          Text("Verify OTP",
              style: TextHelper.h4.copyWith(
                  color: ColorsForApp.headline, fontFamily: semiBoldFont)),
          const SizedBox(height: 8),
          Text("Enter the 6-digit code sent to",
              style: TextHelper.size18.copyWith(
                  color: ColorsForApp.headline, fontFamily: semiBoldFont)),
          const SizedBox(height: 4),
          Text("+91 $phoneNumber",
              style: TextHelper.size18.copyWith(
                  color: ColorsForApp.headline, fontFamily: semiBoldFont)),
          const SizedBox(height: 20),

          // OTP Input
          Obx(() => OutlinedField(
                isFocused: signupController.isOtpFocused.value,
                child: TextField(
                  controller: signupController.otpController,
                  focusNode: signupController.otpFocusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: TextHelper.h5.copyWith(
                      color: ColorsForApp.blackColor,
                      letterSpacing: 4,
                      fontFamily: semiBoldFont),
                  decoration: const InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5, // keeps it comfortable, not too tall/short
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              )),
          const SizedBox(height: 15),

          // Verify Button
          Obx(() => CommonElevatedButton(
              isLoading: signupController.isLoading.value,
              text: 'Verify & Continue',
              icon: Icons.arrow_right_alt_rounded,
              onPressed: () async {
                if (signupController.canSubmit) {
                  bool result = await signupController.verifyRegistrationOtp();
                  if (result) {
                    Get.toNamed(Routes.REGISTRATION_DETAILS_SCREEN);
                  }
                }
              })),
          const SizedBox(height: 15),

          // Change Mobile Number
          GestureDetector(
            onTap: onChangeNumber,
            child: Text("Change mobile number",
                style: TextHelper.size19.copyWith(
                    color: ColorsForApp.primaryColor,
                    fontFamily: semiBoldFont)),
          ),
          const SizedBox(height: 15),
          // Resend OTP or Countdown
          Obx(() => signupController.resendTimer.value > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 5),
                    Text("Resend OTP in ${signupController.resendTimer.value}s",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    if (signupController.canSubmit) {
                      signupController.showOtpScreen.value =
                          await signupController.generateRegistrationOtp();
                      if (signupController.showOtpScreen.value) {
                        signupController.startTimer();
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh,
                          size: 16, color: ColorsForApp.blackColor),
                      const SizedBox(width: 5),
                      Text("Resend OTP",
                          style: TextHelper.size18.copyWith(
                              color: ColorsForApp.blackColor,
                              fontFamily: semiBoldFont)),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
