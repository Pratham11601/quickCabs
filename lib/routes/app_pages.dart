import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:own_idea/binding/landing_page_binding.dart';
import 'package:own_idea/routes/routes.dart';

import '../Screens/landing_page/landing_page.dart';
import '../Screens/splash_screen.dart';
import '../binding/app_binding.dart';

class AppPages {
  AppPages._();
  static const String initialRoute = Routes.SPLASH_SCREEN;

  static final route = [
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: Routes.LANDING_PAGE,
      page: () => LandingScreen(),
      binding: DashBoardBinding(),
    ),
  ];
}
