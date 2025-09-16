import 'package:QuickCab/Screens/profile_module/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../api/api_manager.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/snackbar.dart';
import '../model/create_order_model.dart';
import '../model/packages_model.dart';
import '../model/recharge_razor_model.dart';
import '../model/subscription_status_model.dart';
import '../repository/profile_repository.dart';

/// Controller to manage subscription workflow:
/// - Fetch packages
/// - Create order
/// - Open Razorpay checkout
/// - Verify payment with backend
class SubscriptionController extends GetxController {
  late Razorpay _razorpay;
  final profileController = Get.put(ProfileController()); // ✅ access existing instance
  final ProfileRepository profileRepository = ProfileRepository(APIManager());
  var isActive = false.obs;

  // Observables
  Rx<PackagesModel> packagesModelResponse = PackagesModel().obs;
  Rx<CreateOrderModel> createOrderModelResponse = CreateOrderModel().obs;
  Rx<SubscriptionStatusModel> subscriptionStatusResponse = SubscriptionStatusModel().obs;

  Rx<RechargeRazorModel> rechargeRazorModelResponse = RechargeRazorModel().obs;
  RxString selectedPlanId = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();

    // Razorpay event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Fetch packages initially
    packagesAPI();
  }

  // -------------------- API CALLS --------------------

  /// Fetch packages
  Future<void> packagesAPI() async {
    try {
      isLoading.value = true;
      final response = await profileRepository.getPackagesDetailsApiCall();
      if (response.status != null && response.status != 0) {
        packagesModelResponse.value = response;
      } else {
        ShowSnackBar.info(message: "No packages found");
      }
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Create order with backend
  Future<bool> createOrderAPI(String planId) async {
    try {
      isLoading.value = false;
      final response = await profileRepository.createOrderApiCall(
        params: {"planId": planId},
      );
      if (response.status != null && response.status != 0) {
        createOrderModelResponse.value = response;
        return true;
      } else {
        ShowSnackBar.info(message: response.message ?? "Order not created");
        return false;
      }
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify payment with backend
  Future<void> rechargeRazorAPI({
    required String planId,
    required String orderId,
    required String paymentId,
  }) async {
    try {
      final response = await profileRepository.rechargeRazorApiCall(
        params: {
          "planId": planId,
          "order_id": orderId,
          "payment_id": paymentId,
        },
      );

      if (response.status != null && response.status == 1) {
        rechargeRazorModelResponse.value = response;
        showAppDialog(
          title: rechargeRazorModelResponse.value.message.toString(),
          message:
              'Subscription Plan - ${rechargeRazorModelResponse.value.subscription!.plan}\nStart Date - ${rechargeRazorModelResponse.value.subscription!.startDate}\nEnd Date - ${rechargeRazorModelResponse.value.subscription!.endDate}',
          icon: Icons.check_circle_rounded,
          buttonText: 'OK',
          onConfirm: () {
            Get.back();
          },
        );
      } else {
        ShowSnackBar.info(message: response.message ?? "Recharge failed");
      }
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
    }
  }

  // -------------------- RAZORPAY --------------------

  void openCheckout({
    required String orderId,
    required String planId,
    required int amount,
    required String name,
    required String contact,
    required String email,
  }) {
    var options = {
      'key': 'rzp_live_RECNVaxXQHFOa1', // 🔹 use your test/live key here
      'order_id': orderId, // 🔹 use parameter, not from controller again
      'amount': amount * 100, // 🔹 Razorpay expects amount in paise
      'name': name, // 🔹 from parameter
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'description': 'Quick Cabs Subscription',
    };

    try {
      selectedPlanId.value = planId;
      _razorpay.open(options);
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ShowSnackBar.success(message: "Payment Successful");

    final paymentId = response.paymentId ?? "";
    final orderId = response.orderId ?? createOrderModelResponse.value.order?.id ?? "";

    if (paymentId.isEmpty || orderId.isEmpty) {
      ShowSnackBar.error(message: "Payment data missing. Please contact support.");
      return;
    }

    rechargeRazorAPI(
      planId: selectedPlanId.value,
      orderId: orderId,
      paymentId: paymentId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final errorCode = response.code ?? "Unknown Code";
    final errorMessage = response.message ?? "Something went wrong. Please try again.";

    ShowSnackBar.error(
      message: "Payment failed ($errorCode): $errorMessage",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    final walletName = response.walletName ?? "Unknown Wallet";

    ShowSnackBar.info(
      message: "External Wallet selected: $walletName",
    );
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
