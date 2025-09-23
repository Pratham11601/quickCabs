import 'package:QuickCab/controller/app_update_controller.dart';
import 'package:QuickCab/routes/app_pages.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/theme_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'api/api_manager.dart';
import 'notificaton/firebase_messeges.dart'
    hide flutterLocalNotificationsPlugin;
import 'notificaton/notification_helper.dart';
import 'notificaton/notifications_services.dart';
import 'binding/app_binding.dart';
import 'controller/app_controller.dart';
import 'controller/network_controller.dart';
import 'firebase_options.dart';
import 'languages/languages.dart';
import 'utils/notifications.dart' as notification;

Future<void> inittNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ✅ Create channel explicitly for Android 8+
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(defaultChannel);
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  Get.put(NetworkController()); // inject globally
  Get.put(AppUpdateController());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NotificationService.initialize();
  await inittNotifications();

  await GetServerKey().getServerKeyToken();
  await FirebaseNotification.initialize();
  await NotificationService.initialize();

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
