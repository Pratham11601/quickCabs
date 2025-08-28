import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class NetworkController extends GetxController {
  RxBool isInternetAvailable = false.obs;
  Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? streamSubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    callStreamSubscription();
  }

  Future<void> initConnectivity() async {
    try {
      // checkConnectivity now returns a List<ConnectivityResult>
      final results = await connectivity.checkConnectivity();

      isInternetAvailable.value = results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi);
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
    streamSubscription = connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      try {
        if (results.contains(ConnectivityResult.mobile) ||
            results.contains(ConnectivityResult.wifi)) {
          isInternetAvailable.value = true;
          log('🛜 => 🟢');
        } else if (results.contains(ConnectivityResult.none)) {
          isInternetAvailable.value = false;
          log('🛜 => 🔴');
          Get.toNamed(Routes.NO_INTERNET_CONNECTION_SCREEN);
        } else {
          throw Exception('Network Error, Try after sometime!');
        }
      } catch (e) {
        errorSnackBar(message: e.toString());
      }
    });
  }

  void errorSnackBar({required String message}) {
    Get.snackbar("Error", message);
  }
}
