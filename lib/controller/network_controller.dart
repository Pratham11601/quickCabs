import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class NetworkController extends GetxController {
  RxBool isInternetAvailable = false.obs;
  final Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? streamSubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    callStreamSubscription();
  }

  Future<void> initConnectivity() async {
    try {
      // ✅ returns a single ConnectivityResult
      final result = await connectivity.checkConnectivity();
      _updateConnectionStatus(result as ConnectivityResult);
    } on PlatformException catch (e) {
      errorSnackBar(message: e.message ?? "Connectivity error");
    }
  }

  @override
  void onClose() {
    streamSubscription?.cancel();
    super.onClose();
  }

  void callStreamSubscription() {
    streamSubscription = connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      try {
        if (results.isNotEmpty) {
          _updateConnectionStatus(results.first);
        } else {
          _updateConnectionStatus(ConnectivityResult.none);
        }
      } catch (e) {
        errorSnackBar(message: e.toString());
      }
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      isInternetAvailable.value = true;
      log('🛜 => 🟢');

      // If on no internet screen, close it
      if (Get.currentRoute == Routes.NO_INTERNET_CONNECTION_SCREEN) {
        Get.back();
      }
    } else {
      isInternetAvailable.value = false;
      log('🛜 => 🔴');
      _showNoInternetScreen();
    }
  }

  void _showNoInternetScreen() {
    if (Get.currentRoute != Routes.NO_INTERNET_CONNECTION_SCREEN) {
      Get.toNamed(Routes.NO_INTERNET_CONNECTION_SCREEN);
    }
  }

  void errorSnackBar({required String message}) {
    Get.snackbar("Error", message);
  }
}
