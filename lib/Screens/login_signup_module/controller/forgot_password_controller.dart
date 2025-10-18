import 'dart:async';

import 'package:QuickCab/Screens/login_signup_module/model/forgot_otp_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../../../routes/routes.dart';
import '../../../widgets/snackbar.dart';
import '../model/reset_password_model.dart';
import '../model/verify_sign_in_otp_model.dart';
import '../repository/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  AuthRepository authRepository = AuthRepository(APIManager());

  // Step management: 0 = Forgot Password, 1 = OTP, 2 = Change Password
  var currentStep = 0.obs;
  var mobileError = ''.obs;
  final isPhoneFocused = false.obs; // True when phone field is focused
  final FocusNode phoneFocusNode = FocusNode();
  final isValidNumber = false.obs; // True when phone has 10 digits
  final otpFocusNode = FocusNode();
  final isOtpFocused = false.obs; // True when OTP field is focused
  final confirmFocus = FocusNode();
  final passFocus = FocusNode();
  final isPassFocused = false.obs;

  // Forgot Password fields
  final mobileController = TextEditingController();
  final mobileKey = GlobalKey<FormState>();

  // OTP fields
  final otpController = TextEditingController();
  var secondsRemaining = 30.obs;
  Timer? _timer;
  final isLoading = false.obs;

  // Change Password fields
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordKey = GlobalKey<FormState>();
  final isConfirmFocused = false.obs;
  final isPassObscured = true.obs;
  final isConfirmObscured = true.obs;

  bool get canForgot => isValidNumber.value && !isLoading.value;

  @override
  void onInit() {
    // TODO: implement onInit
    mobileController.addListener(() {
      isValidNumber.value = mobileController.text.length == 10;
    });
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Start OTP timer
  void startTimer() {
    secondsRemaining.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  /// Validate and go to OTP screen
  void sendOtp() {
    if (mobileKey.currentState!.validate()) {
      generateForgotOtp();
      currentStep.value = 1;
      startTimer();
    }
  }

  /// Allow user to go back & change mobile number
  void changeMobileNumber() {
    currentStep.value = 0;
    otpController.clear();
  }

  /// Validate OTP and go to change password screen
  void verifyOtp() {
    if (otpController.text.length == 4) {
      currentStep.value = 2;
    } else {
      Get.snackbar("Invalid OTP", "Please enter a valid 4-digit OTP");
    }
  }

  /// Validate new password and confirm password
  void changePassword() {
    if (passwordKey.currentState!.validate()) {
      if (newPasswordController.text != confirmPasswordController.text) {
        ShowSnackBar.error(title: "Error", message: "Passwords do not match");
        return;
      }
      // TODO: API call for changing password
      resetPassword();
    }
  }

  // Generate mobile otp
  Future<bool> generateForgotOtp({bool isLoaderShow = true}) async {
    isLoading.value = true;
    try {
      ForgotOtpModel model = await authRepository.generateForgotOtpApiCall(params: {
        "phone": mobileController.text.trim(),
      });
      if (model.status == 1) {
        ShowSnackBar.success(message: model.message!);
        isLoading.value = false;

        return true;
      } else {
        ShowSnackBar.info(message: model.message!);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.info(message: e.toString());
      return false;
    }
  }

  // Verify registrationn otp
  Future<bool> verifyForgotOtp({bool isLoaderShow = true}) async {
    isLoading.value = true;
    try {
      VerifySignInOtpModel model = await authRepository.verifyRegistrationOtpApiCall(params: {
        "phone": mobileController.text.trim(),
        "otp": otpController.text.trim(),
      });
      if (model.status == true) {
        ShowSnackBar.success(message: model.message!);
        isLoading.value = false;

        return true;
      } else {
        ShowSnackBar.info(message: model.message!);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.info(message: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword({bool isLoaderShow = true}) async {
    isLoading.value = true;
    try {
      ResetPasswordModel model = await authRepository.resetPasswordApiCall(params: {
        "phone": mobileController.text.trim(),
        "newPassword": newPasswordController.text.trim(),
      });
      if (model.status == true) {
        ShowSnackBar.success(message: model.message!);
        isLoading.value = false;
        Get.offAllNamed(Routes.LOGIN_SCREEN);

        return true;
      } else {
        ShowSnackBar.info(message: model.message!);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.info(message: e.toString());
      return false;
    }
  }
}
