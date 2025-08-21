import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/routes/routes.dart';

class SignupController extends GetxController {
  // Text controllers
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  // Focus
  final phoneFocus = FocusNode();
  final passFocus = FocusNode();
  final confirmFocus = FocusNode();

  // Reactive state
  final isPhoneFocused = false.obs;
  final isPassFocused = false.obs;
  final isConfirmFocused = false.obs;

  final isPassObscured = true.obs;
  final isConfirmObscured = true.obs;

  final isValidPhone = false.obs;
  final isValidPass = false.obs;
  final isConfirmMatch = false.obs;

  final isLoading = false.obs;

  // Derived: enable button if every field valid
  bool get canSubmit => isValidPhone.value && isValidPass.value && isConfirmMatch.value && !isLoading.value;

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
    confirmFocus.addListener(() => isConfirmFocused.value = confirmFocus.hasFocus);
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

    isConfirmMatch.value = confirmCtrl.text.isNotEmpty && confirmCtrl.text == passCtrl.text;
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
      Get.snackbar('Signup failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // phoneCtrl.dispose();
    // passCtrl.dispose();
    // confirmCtrl.dispose();
    // phoneFocus.dispose();
    // passFocus.dispose();
    // confirmFocus.dispose();
    super.onClose();
  }
}
