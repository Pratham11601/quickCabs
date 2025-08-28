import 'package:own_idea/Screens/login_signup_module/model/sign_in_otp_model.dart';
import 'package:own_idea/Screens/login_signup_module/model/verify_sign_in_otp_model.dart';

import '../../../api/api_manager.dart';
import '../model/login_model.dart';

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
}
