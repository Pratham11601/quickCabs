import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/login_signup_module/model/sign_in_otp_model.dart';
import 'package:own_idea/Screens/login_signup_module/model/verify_sign_in_otp_model.dart';
import 'package:own_idea/routes/routes.dart';
import 'package:own_idea/widgets/snackbar.dart';

import '../../../api/api_manager.dart';
import '../repository/auth_repository.dart';

class SignupController extends GetxController {
  AuthRepository authRepository = AuthRepository(APIManager());

  // Text controllers
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  Timer? _timer;

  // Focus
  final phoneFocus = FocusNode();
  final passFocus = FocusNode();
  final confirmFocus = FocusNode();
  final otpFocusNode = FocusNode();

  // Reactive state
  final isPhoneFocused = false.obs;
  final isPassFocused = false.obs;
  final isConfirmFocused = false.obs;
  final isOtpFocused = false.obs; // True when OTP field is focused

  final isValidNumber = false.obs; // True when phone has 10 digits
  final showOtpScreen = false.obs; // Toggles between phone & OTP screen

  final isOtpValid = false.obs; // True when OTP has 6 digits
  final resendTimer = 30.obs; // Timer countdown for resend

  final isPassObscured = true.obs;
  final isConfirmObscured = true.obs;

  final isValidPhone = false.obs;
  final isValidPass = false.obs;
  final isConfirmMatch = false.obs;

  final isLoading = false.obs;

  // Derived: enable button if every field valid
  bool get canSubmit => isValidPhone.value && !isLoading.value;

  // Form key (optional but nice)
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // listeners
    phoneCtrl.addListener(validatePhone);
    passCtrl.addListener(validatePasswords);
    confirmCtrl.addListener(validatePasswords);

    phoneFocus.addListener(() => isPhoneFocused.value = phoneFocus.hasFocus);
    passFocus.addListener(() => isPassFocused.value = passFocus.hasFocus);
    confirmFocus
        .addListener(() => isConfirmFocused.value = confirmFocus.hasFocus);
    _initializeListeners();
  }

  void validatePhone() {
    // India 10-digit mobile without country code
    isValidPhone.value = RegExp(r'^\d{10}$').hasMatch(phoneCtrl.text);
  }

  void validatePasswords() {
    final pass = passCtrl.text;
    // Sample rule: >=6 chars, contains at least one letter and one number
    final lengthOk = pass.length >= 6;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(pass);
    final hasNumber = RegExp(r'\d').hasMatch(pass);
    isValidPass.value = lengthOk && hasLetter && hasNumber;

    isConfirmMatch.value =
        confirmCtrl.text.isNotEmpty && confirmCtrl.text == passCtrl.text;
  }

  Future<void> submit() async {
    if (!canSubmit) return;
    isLoading.value = true;
    try {
      // TODO: call your API here
      // final res = await authRepository.signUp(
      //   phone: '+91${phoneCtrl.text}',
      //   password: passCtrl.text,
      // );
      // handle response / error mapping

      // Navigate after success (adjust to your flow)
      Get.offAllNamed(Routes.DASHBOARD_PAGE);
    } catch (e) {
      Get.snackbar('Signup failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Generate mobile otp
  Future<bool> generateRegistrationOtp({bool isLoaderShow = true}) async {
    isLoading.value = true;
    try {
      SignInOtpModel model =
          await authRepository.generateRegistrationOtpApiCall(params: {
        "phone": phoneCtrl.text.trim(),
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

    // Verify registrationn otp
  Future<bool> verifyRegistrationOtp({bool isLoaderShow = true}) async {
    isLoading.value = true;
    try {
      VerifySignInOtpModel model =
          await authRepository.verifyRegistrationOtpApiCall(params: {
        "phone": phoneCtrl.text.trim(),
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


  void _initializeListeners() {
    // OTP validation (6 digits)
    otpController.addListener(() {
      isOtpValid.value = otpController.text.length == 6;
    });

    // Phone number validation (10 digits)
    phoneCtrl.addListener(() {
      isValidNumber.value = phoneCtrl.text.length == 10;
    });

    // Focus state tracking
    phoneFocus.addListener(() {
      isPhoneFocused.value = phoneFocus.hasFocus;
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
