import 'package:get/get.dart';
import 'package:own_idea/Screens/home_page_module/controller/home_controller.dart';

import '../Screens/landing_page/controller/dashboard_controller.dart';

class DashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
