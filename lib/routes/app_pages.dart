import 'package:QuickCab/Screens/document_verification_module/ui/document_verification_screen.dart';
import 'package:QuickCab/Screens/home_page_module/ui/home_screen.dart';
import 'package:QuickCab/Screens/login_signup_module/ui/signup_screen.dart';
import 'package:QuickCab/Screens/profile_module/ui/help_support_screen.dart';
import 'package:QuickCab/Screens/profile_module/ui/my_documents_screen.dart';
import 'package:QuickCab/binding/dashboard_binding.dart';
import 'package:QuickCab/binding/profile_binding.dart';
import 'package:QuickCab/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Screens/home_page_module/home_widgets/emergency_services_screen.dart';
import '../Screens/landing_page/ui/landing_page.dart';
import '../Screens/login_signup_module/ui/login_screen.dart';
import '../Screens/login_signup_module/ui/user_registration_screen.dart';
import '../Screens/no_internet_connection_screen.dart';
import '../Screens/profile_module/ui/subscription_screen.dart';
import '../Screens/splash_screen.dart';
import '../binding/app_binding.dart';
import '../binding/auth_binding.dart';

class AppPages {
  AppPages._();
  static const String initialRoute = Routes.LOGIN_SCREEN;

  static final route = [
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD_PAGE,
      page: () => DashboardScreen(),
      binding: DashBoardBinding(),
    ),
    GetPage(
      name: Routes.LOGIN_SCREEN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP_SCREEN,
      page: () => SignupScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DOCUMENT_VERIFICATION_PAGE,
      page: () => DocumentVerificationPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME_PAGE,
      page: () => HomeScreen(),
      binding: DashBoardBinding(),
    ),
    GetPage(
      name: Routes.HELP_PAGE,
      page: () => HelpSupportScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.MY_DOCUMENTS,
      page: () => MyDocumentsPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.SUBSCRIPTION,
      page: () => SubscriptionScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.NO_INTERNET_CONNECTION_SCREEN,
      page: () => NoInternetConnectionScreen(),
    ),
    GetPage(
      name: Routes.EMERGENCY_SERVICE_SCREEN,
      page: () => EmergencyServicesScreen(),
      binding: DashBoardBinding(),
    ),
    GetPage(
      name: Routes.REGISTRATION_DETAILS_SCREEN,
      page: () => UserRegistrationScreen(),
      binding: AuthBinding(),
    ),
  ];
}
