import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../../home_page_module/repository/home_repository.dart';
import '../../profile_module/model/subscription_status_model.dart';

class DashboardController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());

  var currentIndex = 0.obs;
  final isLoading = false.obs; // True when API call is in progress

  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    checkSubscriptionStatus();
  }

  RxBool isSubscribed = false.obs;
  Rx<SubscriptionStatusModel> subscriptionStatusModel = SubscriptionStatusModel().obs;

  Future<void> checkSubscriptionStatus() async {
    try {
      isLoading.value = true;
      final response = await authRepository.checkSubscriptionStatusApiCall();
      subscriptionStatusModel.value = response;

      if (response.status == 1) {
        isLoading.value = false;
        isSubscribed.value = response.isSubscribtionActive ?? false;
      } else {
        isSubscribed.value = false;
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      isSubscribed.value = false;
    }
  }
}
