import 'package:get/get.dart';

import '../Screens/profile_module/controller/help_support_controller.dart';
import '../Screens/profile_module/controller/profile_controller.dart';
import '../Screens/profile_module/controller/subscription_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportController>(() => HelpSupportController());
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
