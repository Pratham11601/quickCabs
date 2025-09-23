import 'package:get/get.dart';

class Config {
  Config._();

  static const appName = 'Quick Cabs';
  static  RxBool isInternetAvailable = false.obs;
   static RxBool isNotificationSound = true.obs;
     static RxBool isNotificationEnabled = true.obs;



  // Live
  static const String domainUrl = 'https://quickcabpune.com/dev/api';
  String baseUrl = "$domainUrl/";
}
