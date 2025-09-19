import 'package:QuickCab/routes/app_pages.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/theme_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'api/api_manager.dart';
import 'binding/app_binding.dart';
import 'controller/app_controller.dart';
import 'controller/network_controller.dart';
import 'languages/languages.dart';
import 'utils/notifications.dart' as notification;

Future<void> handleFirebaseNotification(RemoteMessage message) async {
  debugPrint("Foreground message: ${message.toMap()}");
  notification.Notification.showLocalNotification(message);
}

Future<void> handleFirebaseBackgroundNotification(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message: ${message.toMap()}");
  notification.Notification.showLocalNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(NetworkController()); // inject globally

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(handleFirebaseBackgroundNotification);

  await GetStorage.init();
  // Register AppController with GetX
  final appController = Get.put(AppController());

  // Init APIManager with AppController
  APIManager.init(appController);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.orange,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const App());

  FirebaseMessaging.onMessage.listen(handleFirebaseNotification);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("App opened from notification: ${message.toMap()}");
    notification.Notification.showLocalNotification(message);
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: "Quick Cab",
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme(),
          builder: EasyLoading.init(), // ✅ VERY IMPORTANT
          initialRoute: AppPages.initialRoute,
          initialBinding: AppBinding(),
          getPages: AppPages.route,
          translations: Languages(),
          locale: Get.deviceLocale, // default device locale
          fallbackLocale: const Locale('en', 'US'), // fallback locale
        );
      },
    );
  }
}
