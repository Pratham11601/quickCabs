import 'package:QuickCab/Screens/post_lead_module/model/location_fetch_model.dart';

import '../../../api/api_manager.dart';
import '../model/post_lead_model.dart';

class PostLeadRepository {
  final APIManager apiManager;
  PostLeadRepository(this.apiManager);

  Future<PostLeadModel> postLeadApiCall({
    required Map<String, dynamic> params,
    bool isLoaderShow = true,
  }) async {
    var jsonData = await apiManager.postAPICall(
      url: '/leads/post-lead',
      params: params,
    );
    return PostLeadModel.fromJson(jsonData);
  }

  Future<LocationFetchModel> fetchLocationForPost({
    required String location,
    bool isLoaderShow = true,
  }) async {
    final jsonData = await apiManager.getAPICall(
      url: '/google/find?query=$location',
    );
    return LocationFetchModel.fromJson(jsonData);
  }
}
