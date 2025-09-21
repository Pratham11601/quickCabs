import 'package:QuickCab/Screens/home_page_module/model/banner_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/live_lead_model.dart';

import '../../../api/api_manager.dart';
import '../model/active_lead_model.dart';
import '../model/all_live_lead_model.dart';

class ActiveLeadRepository {
  final APIManager apiManager;
  ActiveLeadRepository(this.apiManager);

  //Active lead api call
  Future<ActiveLeadModel> activeLeadApiCall(
      dynamic pageNumber, String? fromLoaction, String? toLoacation) async {
    var jsonData = await apiManager.getAPICall(
      url:
          '/leads/active?location_from=$fromLoaction&to_location=$toLoacation&page=$pageNumber&pageSize=10',
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

  //Live Lead api call
  Future<LiveLeadModel> myAvailabilityApiCall(dynamic pageNumber) async {
    var jsonData = await apiManager.getAPICall(
      url: '/driver-availability/my-avability?page=$pageNumber&pageSize=10',
    );
    var response = LiveLeadModel.fromJson(jsonData);
    return response;
  }

  Future<AllLiveLeadModel> allDriverAvailabilityApiCall(
      dynamic pageNumber) async {
    var jsonData = await apiManager.getAPICall(
      url: '/driver-availability/get-all-active?page=$pageNumber&pageSize=10',
    );
    var response = AllLiveLeadModel.fromJson(jsonData);
    return response;
  }
}
