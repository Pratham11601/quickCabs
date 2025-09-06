import 'package:own_idea/Screens/profile_module/model/create_order_model.dart';
import 'package:own_idea/Screens/profile_module/model/packages_model.dart';
import 'package:own_idea/Screens/profile_module/model/profile_details_model.dart';
import 'package:own_idea/Screens/profile_module/model/recharge_razor_model.dart';

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

  Future<PackagesModel> getPackagesDetailsApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: '/sub_packages',
    );
    var response = PackagesModel.fromJson(jsonData);
    return response;
  }

  Future<CreateOrderModel> createOrderApiCall({
    required Map<String, dynamic> params,
  }) async {
    var jsonData = await apiManager.postAPICall(
      url: '/vendorDetails/create-order',
      params: params,
    );
    var response = CreateOrderModel.fromJson(jsonData);
    return response;
  }

  Future<RechargeRazorModel> rechargeRazorApiCall({
    required Map<String, dynamic> params,
  }) async {
    var jsonData = await apiManager.postAPICall(
      url: 'vendorDetails/recharge-on-razorpay',
      params: params,
    );
    var response = RechargeRazorModel.fromJson(jsonData);
    return response;
  }
}
