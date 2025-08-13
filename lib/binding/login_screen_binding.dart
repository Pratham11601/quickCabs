import 'package:get/get.dart';
import 'package:own_idea/Screens/login_module/controller/login_controller.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
