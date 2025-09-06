import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../../home_page_module/repository/home_repository.dart';
import '../../profile_module/model/subscription_status_model.dart';

class DashboardController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());

  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  RxBool isSubscribed = false.obs;
  Rx<SubscriptionStatusModel> subscriptionStatusModel = SubscriptionStatusModel().obs;

  Future<bool> checkSubscriptionStatus() async {
    try {
      subscriptionStatusModel.value = await authRepository.checkSubscriptionStatusApiCall();
      if (subscriptionStatusModel.value.status == 1) {
        isSubscribed.value = subscriptionStatusModel.value.isSubscribtionActive ?? false;
        return true;
      } else {
        isSubscribed.value = false;
        return false;
      }
    } catch (e) {
      isSubscribed.value = false;
      return false;
    }
  }
}
