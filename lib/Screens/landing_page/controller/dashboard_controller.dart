import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../../home_page_module/repository/home_repository.dart';
import '../../profile_module/model/subscription_status_model.dart';

class DashboardController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());

  var currentIndex = 0.obs;
  final isLoading = false.obs; // True when API call is in progress
  DateTime? lastCheckedTime;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  RxBool isSubscribed = false.obs;
  Rx<SubscriptionStatusModel> subscriptionStatusModel = SubscriptionStatusModel().obs;

  Future<void> checkSubscriptionStatus() async {
    try {
      isLoading.value = true;
      final response = await authRepository.checkSubscriptionStatusApiCall();
      subscriptionStatusModel.value = response;

      if (response.status == 1) {
        // check both top-level and nested subscription.isActive
        bool active = response.isSubscribtionActive == true || (response.subscription?.isActive == true);

        isSubscribed.value = active;
      } else {
        isSubscribed.value = false;
      }
    } catch (e) {
      isSubscribed.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
