import 'package:own_idea/Screens/profile_module/model/profile_details_model.dart';

import '../../api/api_manager.dart';

class ProfileRepository {
  final APIManager apiManager;
  ProfileRepository(this.apiManager);

  //Call to get profile details
  Future<ProfileDetailsModel> getProfileDetailsApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: '/vendorDetails/user-details',
    );
    var response = ProfileDetailsModel.fromJson(jsonData);
    return response;
  }
}
