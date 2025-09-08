import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../../api/api_manager.dart';
import '../../../utils/app_colors.dart';
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
      if (response.status == 1) {
        final homeController = Get.find<HomeController>();
        final acceptedLeadId = response.lead.id;
        final acceptedById = response.lead.acceptedById;
        final index = homeController.activeLeads.indexWhere((post) => post.id == acceptedLeadId);


        if (index != -1) {
          homeController.activeLeads[index].acceptedById = acceptedById;
          homeController.activeLeads.refresh();
        }

        showSuccess.value = true;
        showError.value = false;

        if (context.mounted) {
          Get.back();
        }
        Get.snackbar(
          'Success',
          'Lead accepted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorsForApp.primaryColor,
          colorText: Colors.white,

          margin: EdgeInsets.all(12),
          duration: Duration(seconds: 2),

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
