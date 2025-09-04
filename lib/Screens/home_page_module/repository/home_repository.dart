import 'package:own_idea/Screens/home_page_module/model/check_profile_completion_model.dart';

import '../../../api/api_manager.dart';

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
}
