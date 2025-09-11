import 'package:QuickCab/Screens/my_leads_module/controller/my_lead_controller.dart';
import 'package:QuickCab/Screens/post_lead_module/controller/post_controller.dart';
import 'package:QuickCab/Screens/profile_module/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../Screens/home_page_module/controller/home_controller.dart';
import '../Screens/landing_page/controller/dashboard_controller.dart';
import '../Screens/profile_module/controller/subscription_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MyLeadsController>(() => MyLeadsController());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
