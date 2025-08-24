import 'package:get/get.dart';

import '../Screens/profile_module/controller/help_support_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportController>(() => HelpSupportController());
  }
}
