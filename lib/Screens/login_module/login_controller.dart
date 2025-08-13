import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  var isOtpValid = false.obs;
  var resendTimer = 30.obs;
  Timer? _timer;
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();

  var isFocused = false.obs;
  var isValidNumber = false.obs;
  var showOtpScreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    //for otp on login
    otpController.addListener(() {
      isOtpValid.value = otpController.text.length == 6;
    });
    startTimer();

    // Listen for focus change
    phoneFocusNode.addListener(() {
      isFocused.value = phoneFocusNode.hasFocus;
    });

    // Listen for focus change
    otpFocusNode.addListener(() {
      isFocused.value = otpFocusNode.hasFocus;
    });

    // Listen for phone input
    phoneController.addListener(() {
      isValidNumber.value = phoneController.text.length == 10;
    });
  }

  void startTimer() {
    resendTimer.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    // Your resend logic here
    startTimer();
  }

  void sendOtp() {
    showOtpScreen.value = true;
    // Add actual send OTP API call here
  }

  void changeMobileNumber() {
    showOtpScreen.value = false;
  }

  void verifyOtp() {
    // Your verify logic here
  }

  @override
  void onClose() {
    super.onClose();
  }
}
