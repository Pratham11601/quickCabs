import 'package:QuickCab/Screens/home_page_module/model/banner_model.dart';

import '../../../api/api_manager.dart';
import '../model/active_lead_model.dart';

class ActiveLeadRepository {
  final APIManager apiManager;
  ActiveLeadRepository(this.apiManager);

  //Active lead api call
  Future<ActiveLeadModel> activeLeadApiCall(dynamic pageNumber) async {
    var jsonData = await apiManager.getAPICall(
      url: '/leads/active?page=$pageNumber&pageSize=10',
    );
    var response = ActiveLeadModel.fromJson(jsonData);
    return response;
  }

  Future<List<BannerModel>> fetchBannersApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: '/advertise',
    );

    // ensure response is a List
    if (jsonData is List) {
      return jsonData.map((e) => BannerModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
