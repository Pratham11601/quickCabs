import 'dart:async';

import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../repository/accept_lead_repository.dart';
import 'home_controller.dart';

class AcceptLeadOtpPopupController extends GetxController {
  final AcceptLeadRepository repository = AcceptLeadRepository(APIManager());

  final int leadId;
  AcceptLeadOtpPopupController({required this.leadId});

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

  Future<void> handleAcceptLead(BuildContext context) async {
    FocusScope.of(context).unfocus();
    debugPrint('Sending OTP: ${otpText.value} for leadId: $leadId');

    try {
      final response = await repository.acceptLeadApiCall(
        leadId: leadId,
        otp: otpText.value,
      );

      debugPrint('Response status: ${response.status}');
      debugPrint('Response message: ${response.message}');

      final homeController = Get.find<HomeController>();

      if (response.status == 1) {
        final acceptedLeadId = response.lead.id;

        // ✅ Find index
        final index = homeController.activeLeads.indexWhere((lead) => lead.id == acceptedLeadId);

        if (index != -1) {
          // Update the status or acceptedById property
          homeController.activeLeads[index].isActive = 0; // or status = 'Booked'
          homeController.activeLeads[index].acceptedById = response.lead.acceptedById;

          // ✅ Trigger UI refresh
          homeController.activeLeads[index] = homeController.activeLeads[index];
          homeController.activeLeads.refresh();
        }

        showSuccess.value = true;
        showError.value = false;

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
      }
    } catch (e) {
      debugPrint('Error during acceptLeadApiCall: $e');
      showError.value = true;
      showSuccess.value = false;
    }
  }
}
