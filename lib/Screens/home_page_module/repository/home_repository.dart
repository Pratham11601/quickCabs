import 'package:QuickCab/Screens/home_page_module/model/check_profile_completion_model.dart';

import '../../../api/api_manager.dart';
import '../../profile_module/model/subscription_status_model.dart';

class HomeRepository {
  final APIManager apiManager;
  HomeRepository(this.apiManager);

  Future<CheckProfileCompletionModel> checkProfileCompletionApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: '/vendorDetails/checkProfileCompletion',
    );
    var response = CheckProfileCompletionModel.fromJson(jsonData);
    return response;
  }

  //Call to check profile completion
  Future<SubscriptionStatusModel> checkSubscriptionStatusApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: '/vendorDetails/check-subscription',
    );
    var response = SubscriptionStatusModel.fromJson(jsonData);
    return response;
  }
}
