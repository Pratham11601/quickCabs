import 'package:QuickCab/Screens/login_signup_module/ui/widgets/otp_verify_container.dart';
import 'package:QuickCab/generated/assets.dart';
import 'package:QuickCab/widgets/common_elevated_button.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller = Get.find();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => CustomAppBar(
            title: "Forgot Password",
            subtitle: controller.currentStep.value == 0
                ? "Enter your mobile number"
                : controller.currentStep.value == 1
                    ? "Verify the OTP"
                    : "Set your new password",
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),

                /// ---------- Step UI ----------
                if (controller.currentStep.value == 0) _forgotPasswordUI(),
                if (controller.currentStep.value == 1)
                  OtpVerifyContainer(phoneNumber: controller.mobileController.text, onChangeNumber: controller.changeMobileNumber),
                if (controller.currentStep.value == 2) _changePasswordUI(),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// ---------- Forgot Password UI ----------
  Widget _forgotPasswordUI() {
    return Form(
      key: controller.mobileKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),

          /// ---------- Header Image ----------
          SvgPicture.asset(
            Assets.imagesForgetPasswordImage,
            height: 400,
            width: 200,
            fit: BoxFit.contain,
          ),
          Obx(() => OutlinedField(
                isFocused: controller.isPhoneFocused.value,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(Icons.call_outlined, color: ColorsForApp.primaryColor, size: 20), // smaller to match
                    const SizedBox(width: 10),
                    Text(
                      '+91',
                      style: TextHelper.size19.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 1, height: 24, color: Colors.grey.shade300),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.mobileController,
                        focusNode: controller.phoneFocusNode,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Enter 10-digit mobile number',
                          hintStyle: TextHelper.size19.copyWith(
                            color: ColorsForApp.subtle,
                          ),
                        ),
                        style: TextHelper.size19.copyWith(
                          color: ColorsForApp.blackColor,
                          fontFamily: semiBoldFont,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          const SizedBox(height: 20),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.mobileController.text.isEmpty) {
                      ShowSnackBar.error(
                        title: "Validation Error",
                        message: "Mobile number is required",
                      );
                    } else if (controller.mobileController.text.length != 10) {
                      ShowSnackBar.error(
                        title: "Validation Error",
                        message: "Enter valid 10-digit number",
                      );
                    } else {
                      // ✅ If validation passes
                      controller.sendOtp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isValidNumber.value ? ColorsForApp.primaryColor : ColorsForApp.cta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed',
                        style: TextHelper.h6.copyWith(
                          color: ColorsForApp.whiteColor,
                          fontFamily: semiBoldFont,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        size: 35,
                        color: ColorsForApp.whiteColor,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  /// ---------- Change Password UI ----------
  Widget _changePasswordUI() {
    return Form(
      key: controller.passwordKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),

          /// ---------- Header Image ----------
          SvgPicture.asset(
            Assets.imagesForgetPasswordImage,
            height: 400,
            width: 200,
            fit: BoxFit.contain,
          ),
          // Password
          Text('Password', style: TextHelper.size19.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
          const SizedBox(height: 8),
          Obx(() => OutlinedField(
                isFocused: controller.isPassFocused.value,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(Icons.lock_outline, color: ColorsForApp.primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: controller.newPasswordController,
                        focusNode: controller.passFocus,
                        obscureText: controller.isPassObscured.value,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorStyle: TextHelper.size15.copyWith(color: ColorsForApp.red),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, // keeps it comfortable, not too tall/short
                          ),
                          hintText: 'Enter password (min. 6 chars)',
                          hintStyle: TextHelper.size19.copyWith(color: ColorsForApp.subtle),
                        ),
                        style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor),
                        validator: (value) {
                          if (controller.newPasswordController.text.trim().isEmpty) {
                            return 'Please enter password';
                          } else if (value!.length < 6) {
                            return 'Please enter at least 6 Characters password';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.isPassObscured.toggle(),
                      icon: Icon(
                        controller.isPassObscured.value ? Icons.visibility_off : Icons.visibility,
                        color: ColorsForApp.subtle,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 15),

          // Confirm
          Text('Confirm Password', style: TextHelper.size19.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
          const SizedBox(height: 8),
          Obx(() => OutlinedField(
                isFocused: controller.isConfirmFocused.value,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(Icons.lock_outline, color: ColorsForApp.primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: controller.confirmPasswordController,
                        focusNode: controller.confirmFocus,
                        obscureText: controller.isConfirmObscured.value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, // keeps it comfortable, not too tall/short
                          ),
                          border: InputBorder.none,
                          errorStyle: TextHelper.size15.copyWith(color: ColorsForApp.red),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Confirm your password',
                          hintStyle: TextHelper.size19.copyWith(color: ColorsForApp.subtle),
                        ),
                        style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor),
                        validator: (value) {
                          if (controller.confirmPasswordController.text.trim().isEmpty) {
                            return 'Please enter confirm password';
                          } else if (controller.newPasswordController.text != value) {
                            return 'New password & confirm password must be same';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.isConfirmObscured.toggle(),
                      icon: Icon(
                        controller.isConfirmObscured.value ? Icons.visibility_off : Icons.visibility,
                        color: ColorsForApp.subtle,
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 20),
          CommonElevatedButton(
            onPressed: controller.changePassword,
            text: 'Change Password',
          ),
        ],
      ),
    );
  }
}
