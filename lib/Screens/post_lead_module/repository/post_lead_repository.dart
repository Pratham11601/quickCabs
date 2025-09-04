import 'package:own_idea/Screens/post_lead_module/model/post_lead_model.dart';

import '../../../api/api_manager.dart';

class PostLeadRepository
{
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

}