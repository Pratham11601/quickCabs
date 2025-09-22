import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> getAppVersionText() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version; // e.g., 2.1.0
  return "app_version_info".tr.replaceAll("{version}", version);
}
