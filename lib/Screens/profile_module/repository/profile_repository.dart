import 'dart:io';

import 'package:QuickCab/Screens/profile_module/model/help_support_model.dart';
import 'package:QuickCab/Screens/profile_module/model/logout_model.dart';

import '../../../api/api_manager.dart';
import '../../login_signup_module/model/user_registration_model.dart';
import '../model/create_order_model.dart';
import '../model/packages_model.dart';
import '../model/profile_details_model.dart';
import '../model/recharge_razor_model.dart';

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
      url: '/vendorDetails/recharge-on-razorpay',
      params: params,
    );
    var response = RechargeRazorModel.fromJson(jsonData);
    return response;
  }

  Future<HelpSupportModel> getHelpSupport() async {
    var jsonData = await apiManager.getAPICall(url: '/contact-support/get-all');
    var response = HelpSupportModel.fromJson(jsonData);
    return response;
  }

    Future<UserRegistrationModel> reuploadDocuments({
    required Map<String, dynamic> params,
    Map<String, File>? files,
    Map<String, List<int>>? byteFiles,
  }) async {
    var jsonData = await apiManager.multipartPost2APICall(
      url: "/vendorDetails/upload-images",
      params: params,
      byteFiles: byteFiles,
    );

    return UserRegistrationModel.fromJson(jsonData);
  }

    Future<LogoutModel> logoutApiCall(
      {required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '/vendorDetails/logout',
      params: params,
    );
    var response = LogoutModel.fromJson(jsonData);
    return response;
  }
}
