import 'dart:io';

import '../../../api/api_manager.dart';
import '../model/lead_by_model.dart';
import '../model/login_model.dart';
import '../model/sign_in_otp_model.dart';
import '../model/user_registration_model.dart';
import '../model/verify_sign_in_otp_model.dart';

class AuthRepository {
  final APIManager apiManager;
  AuthRepository(this.apiManager);

  //Login api
  Future<LoginModel> loginApiCall(
      {required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '/vendorDetails/login',
      params: params,
    );
    var response = LoginModel.fromJson(jsonData);
    return response;
  }

  // Generate registration otp
  Future<SignInOtpModel> generateRegistrationOtpApiCall({
    required Map<String, dynamic> params,
  }) async {
    var jsonData = await apiManager.postAPICall(
      url: '/vendorDetails/send-otp',
      params: params,
    );
    var response = SignInOtpModel.fromJson(jsonData);
    return response;
  }

  // Verify  registration otp
  Future<VerifySignInOtpModel> verifyRegistrationOtpApiCall({
    required Map<String, dynamic> params,
  }) async {
    var jsonData = await apiManager.postAPICall(
      url: '/vendorDetails/verify-otp',
      params: params,
    );
    var response = VerifySignInOtpModel.fromJson(jsonData);
    return response;
  }

// Get Lead By List
  Future<LeadByListModel> getLeadByListApiCall() async {
    var jsonData = await apiManager.getAPICall(url: '/sub-admin/get-all');
    var response = LeadByListModel.fromJson(jsonData);
    return response;
  }

  // User  registration
  // Future<UserRegistrationModel> userRegistrationApiCall({
  //   required Map<String, dynamic> params,
  // }) async {
  //   var jsonData = await apiManager.postAPICall(
  //     url: '/vendorDetails/registervendorDetails/verify-otp',
  //     params: params,
  //   );
  //   var response = UserRegistrationModel.fromJson(jsonData);
  //   return response;
  // }

  Future<UserRegistrationModel> registerVendor({
    required Map<String, dynamic> params,
    Map<String, File>? files,
    Map<String, List<int>>? byteFiles,
  }) async {
    var jsonData = await apiManager.multipartPost2APICall(
      url: "/vendorDetails/registers-user",
      params: params,
      byteFiles: byteFiles,
    );

    return UserRegistrationModel.fromJson(jsonData);
  }
}
