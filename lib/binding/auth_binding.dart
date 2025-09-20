import 'package:QuickCab/Screens/login_signup_module/controller/forgot_password_controller.dart';
import 'package:QuickCab/Screens/login_signup_module/controller/user_registration_controller.dart';
import 'package:get/get.dart';

import '../Screens/login_signup_module/controller/login_controller.dart';
import '../Screens/login_signup_module/controller/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(), fenix: true);
    Get.lazyPut<UserRegistrationController>(() => UserRegistrationController(), fenix: true);
  }
}
