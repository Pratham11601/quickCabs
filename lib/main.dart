import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:own_idea/routes/app_pages.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:own_idea/utils/theme_config.dart';
import 'package:sizer/sizer.dart';

import 'api/api_manager.dart';
import 'binding/app_binding.dart';
import 'controller/app_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          initialRoute: AppPages.initialRoute,
          initialBinding: AppBinding(),
          getPages: AppPages.route,
        );
      },
    );
  }
}
