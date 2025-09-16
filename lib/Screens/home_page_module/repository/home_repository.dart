import 'package:QuickCab/Screens/home_page_module/model/check_profile_completion_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/driver_availability_model.dart';

import '../../../api/api_manager.dart';
import '../../profile_module/model/subscription_status_model.dart';
import '../model/vendor_emergency_model.dart';

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

  // Call Vendors api for emergency services
  Future<VendorResponse> getVendors({
    required String category,
    required int page,
    required int limit,
  }) async {
    // Build query parameters map
    final Map<String, dynamic> queryParams = {
      "category": category,
      "page": page.toString(),
      "limit": limit.toString(),
    };

    // Call API
    var jsonData = await apiManager.getAPICall(
      url: '/vendorDetails/get-all',
      queryParameters: queryParams, // pass map, not undefined 'params'
    );

    return VendorResponse.fromJson(jsonData);
  }

  Future<DriverAvailabilityModel> postDriverAvailabilityApiCall({
    required Map<String, dynamic> params,
    bool isLoaderShow = true,
  }) async {
    var jsonData = await apiManager.postAPICall(
      url: '/driver-availability/post-avability',
      params: params,
    );
    return DriverAvailabilityModel.fromJson(jsonData);
  }
}
