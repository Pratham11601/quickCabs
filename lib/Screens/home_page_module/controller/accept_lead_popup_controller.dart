import 'dart:async';

import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../repository/accept_lead_repository.dart';

class AcceptLeadOtpPopupController extends GetxController {
  final AcceptLeadRepository repository = AcceptLeadRepository(APIManager());

  final int leadId;
  AcceptLeadOtpPopupController({required this.leadId});

  final RxString otpText = "".obs;
  final RxInt timerSeconds = 30.obs;
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
    timerSeconds.value = 30;

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

  Future<void> handleAcceptLead(BuildContext context) async {
    FocusScope.of(context).unfocus();
    debugPrint('Sending OTP: ${otpText.value} for leadId: $leadId');

    try {
      final response = await repository.acceptLeadApiCall(
        leadId: leadId,
        otp: otpText.value,
      );

      if (response.status == 1) {
        showError.value = false;
        showSuccess.value = true;

        if (context.mounted) {
          Get.back();
        }

        ShowSnackBar.success(
          title: 'Success',
          message: 'Lead accepted successfully',
        );
      } else {
        showError.value = true;
        showSuccess.value = false;
        ShowSnackBar.error(
          title: 'Error',
          message: response.message ?? 'Failed to accept lead',
        );
      }
    } catch (e) {
      debugPrint('Error during acceptLeadApiCall: $e');
      showError.value = true;
      showSuccess.value = false;
    }
  }
}
