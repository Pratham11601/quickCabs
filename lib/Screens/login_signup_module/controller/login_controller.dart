import 'dart:async';

import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/storage_config.dart';
import '../model/login_model.dart';
import '../repository/auth_repository.dart';

/// Controller for managing login & OTP verification logic.
/// Uses GetX for state management and reactive variables.
class LoginController extends GetxController {
  AuthRepository authRepository = AuthRepository(APIManager());
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // ---------------------- Text Controllers ----------------------
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ---------------------- Focus Nodes ----------------------
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // ---------------------- Reactive State ----------------------

  final isPhoneFocused = false.obs; // True when phone field is focused
  final isPasswordFocused = false.obs; // True when password field is focused
  final isValidNumber = false.obs; // True when phone has 10 digits
  final isLoading = false.obs; // True when API call is in progress
  final rememberMe = false.obs; // Observable variable to track Remember Me checkbox
  final isPasswordVisible = false.obs;
  // ---------------------- Timer ----------------------

  // =====================================================
  // LIFECYCLE METHODS
  // =====================================================

  @override
  void onInit() {
    // TODO: implement onInit
    phoneController.addListener(() {
      isValidNumber.value = phoneController.text.length == 10;
    });

    /// Restore saved credentials if Remember Me was enabled
    loadSavedCredentials();
    super.onInit();
  }

  /// Load saved credentials if Remember Me was enabled
  Future<void> loadSavedCredentials() async {
    final savedRemember = await LocalStorage.fetchValue(StorageKey.rememberMe);

    if (savedRemember == "true") {
      rememberMe.value = true;
      phoneController.text = await LocalStorage.fetchValue(StorageKey.user) ?? "";
      passwordController.text = await LocalStorage.fetchValue(StorageKey.password) ?? "";
    }
  }

  Future<bool> isUserLoggedIn() async {
    final token = await LocalStorage.fetchValue(StorageKey.token);
    return token != null && token.isNotEmpty;
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
    super.onClose();
  }

  // =====================================================
  // INITIALIZATION HELPERS
  // =====================================================

  /// Attach listeners for validation & focus states

  // Login  api
  Rx<LoginModel> loginModelResponse = LoginModel().obs;

  Future<bool> loginAPI({bool isLoaderShow = true}) async {
    try {
      isLoading.value = true;
      LoginModel loginModel = await authRepository.loginApiCall(isLoaderShow: isLoaderShow, params: {
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
      });
      if (loginModel.token != null && loginModel.token!.isNotEmpty) {
        loginModelResponse.value = loginModel;
        // Save token for session
        await LocalStorage.storeValue(StorageKey.token, loginModel.token.toString());

        // ✅ Save credentials if Remember Me is checked
        if (rememberMe.value) {
          await LocalStorage.storeValue(StorageKey.rememberMe, "true");
          await LocalStorage.storeValue(StorageKey.user, phoneController.text.trim());
          await LocalStorage.storeValue(StorageKey.password, passwordController.text.trim());
        } else {
          await LocalStorage.storeValue(StorageKey.rememberMe, "false");
          await LocalStorage.removeValue(StorageKey.user);
          await LocalStorage.removeValue(StorageKey.password);
        }

        if (loginModel.message != null && loginModel.message!.isNotEmpty) {
          isLoading.value = false;
          ShowSnackBar.success(message: loginModel.message!.toString());
        }
        return true;
      } else {
        isLoading.value = false;
        ShowSnackBar.info(message: loginModel.message.toString(), title: 'Alert');
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.error(message: e.toString());
      return false;
    }
  }
}
