import 'package:QuickCab/Screens/home_page_module/model/banner_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/live_lead_model.dart';

import '../../../api/api_manager.dart';
import '../../history_module/lead_history_model.dart';
import '../model/active_lead_model.dart';
import '../model/all_live_lead_model.dart';
import '../model/news_model.dart';

class ActiveLeadRepository {
  final APIManager apiManager;
  ActiveLeadRepository(this.apiManager);

  //Active lead api call
  Future<ActiveLeadModel> activeLeadApiCall(dynamic pageNumber, String? fromLoaction, String? toLoacation) async {
    var jsonData = await apiManager.getAPICall(
      url: '/leads/active?location_from=$fromLoaction&to_location=$toLoacation&page=$pageNumber&pageSize=10',
    );
    var response = ActiveLeadModel.fromJson(jsonData);
    return response;
  }

  Future<LeadHistoryModel> leadHistoryApiCall(dynamic pageNumber, String? fromLoaction, String? toLoacation) async {
    var jsonData = await apiManager.getAPICall(
      url: '/leads/all?page=$pageNumber&pageSize=10',
    );
    var response = LeadHistoryModel.fromJson(jsonData);
    return response;
  }

  Future<BannerModel> fetchBannersApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: '/advertise/get',
    );
    var response = BannerModel.fromJson(jsonData);
    return response;
  }

  Future<NewsModel> fetchNewsApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: '/announcements/all',
    );
    var response = NewsModel.fromJson(jsonData);
    return response;
  }

  //Live Lead api call
  Future<LiveLeadModel> myAvailabilityApiCall(dynamic pageNumber) async {
    var jsonData = await apiManager.getAPICall(
      url: '/driver-availability/my-avability?page=$pageNumber&pageSize=10',
    );
    var response = LiveLeadModel.fromJson(jsonData);
    return response;
  }

  Future<AllLiveLeadModel> allDriverAvailabilityApiCall(dynamic pageNumber) async {
    var jsonData = await apiManager.getAPICall(
      url: '/driver-availability/get-all-active?page=$pageNumber&pageSize=10',
    );
    var response = AllLiveLeadModel.fromJson(jsonData);
    return response;
  }
}
