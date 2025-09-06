import 'package:get/get.dart';
import 'package:own_idea/Screens/profile_module/controller/profile_controller.dart';
import 'package:own_idea/Screens/profile_module/controller/subscription_controller.dart';

import '../Screens/profile_module/controller/help_support_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportController>(() => HelpSupportController());
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
