import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AcceptLeadOtpPopupController extends GetxController {
  final RxString otpText = "".obs;
  final RxInt timerSeconds = 17.obs;
  final RxBool showError = false.obs;
  final RxBool showSuccess = false.obs;
  final RxBool isCountdownActive = true.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    isCountdownActive.value = true;
    timerSeconds.value = 17;

    // Cancel existing timer if any before starting new
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 1) {
        timerSeconds.value--;
      } else {
        isCountdownActive.value = false;
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    // api here
    startTimer();
  }

  void handleAcceptLead(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (otpText.value == "1234") {
      showSuccess.value = true;
      showError.value = false;
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        Get.back();
      }
    } else {
      showError.value = true;
      showSuccess.value = false;
      await Future.delayed(const Duration(seconds: 1));
      showError.value = false;
    }
  }
}
