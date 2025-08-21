import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

/// Controller for managing login & OTP verification logic.
/// Uses GetX for state management and reactive variables.
class LoginController extends GetxController {
  // ---------------------- Text Controllers ----------------------
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // ---------------------- Focus Nodes ----------------------
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();

  // ---------------------- Reactive State ----------------------
  final isOtpValid = false.obs; // True when OTP has 6 digits
  final resendTimer = 30.obs; // Timer countdown for resend
  final isPhoneFocused = false.obs; // True when phone field is focused
  final isOtpFocused = false.obs; // True when OTP field is focused
  final isValidNumber = false.obs; // True when phone has 10 digits
  final showOtpScreen = false.obs; // Toggles between phone & OTP screen

  // ---------------------- Timer ----------------------
  Timer? _timer;

  // =====================================================
  // LIFECYCLE METHODS
  // =====================================================

  @override
  void onInit() {
    super.onInit();
    _initializeListeners();
    startTimer();
  }

  @override
  void onClose() {
    // Dispose controllers & cancel timer to prevent memory leaks
    // phoneFocusNode.removeListener(() {});
    // otpFocusNode.removeListener(() {});
    // phoneController.dispose();
    // otpController.dispose();
    // phoneFocusNode.dispose();
    // otpFocusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }

  // =====================================================
  // INITIALIZATION HELPERS
  // =====================================================

  /// Attach listeners for validation & focus states
  void _initializeListeners() {
    // OTP validation (6 digits)
    otpController.addListener(() {
      isOtpValid.value = otpController.text.length == 6;
    });

    // Phone number validation (10 digits)
    phoneController.addListener(() {
      isValidNumber.value = phoneController.text.length == 10;
    });

    // Focus state tracking
    phoneFocusNode.addListener(() {
      isPhoneFocused.value = phoneFocusNode.hasFocus;
    });

    otpFocusNode.addListener(() {
      isOtpFocused.value = otpFocusNode.hasFocus;
    });
  }

  // =====================================================
  // OTP HANDLING
  // =====================================================

  /// Start countdown timer for resend OTP
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

  /// Resend OTP logic
  void resendOtp() {
    // TODO: Add resend OTP API call here
    startTimer();
  }

  /// Trigger OTP sending process
  void sendOtp() {
    // TODO: Add send OTP API call here
    showOtpScreen.value = true;
    startTimer();
  }

  /// Allow user to go back & change mobile number
  void changeMobileNumber() {
    showOtpScreen.value = false;
    otpController.clear();
  }

  /// Verify OTP and proceed to next screen
  void verifyOtp() {
    // TODO: Replace with actual OTP verification API call
    Get.offAllNamed(Routes.DOCUMENT_VERIFICATION_PAGE);
  }
}
