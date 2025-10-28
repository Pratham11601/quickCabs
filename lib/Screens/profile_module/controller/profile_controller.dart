import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:QuickCab/Screens/profile_module/model/logout_model.dart';
import 'package:QuickCab/Screens/profile_module/model/profile_details_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_manager.dart';
import '../../../notificaton/notifications_services.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/config.dart';
import '../../../widgets/snackbar.dart';
import '../../document_verification_module/model/docItemModel.dart';
import '../../document_verification_module/model/upload_source.dart';
import '../../document_verification_module/ui/uploadSheet.dart';
import '../../landing_page/controller/dashboard_controller.dart';
import '../repository/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileRepository profileRepository = ProfileRepository(APIManager());
  final DashboardController dashboardController = Get.find();

  /// Subscription
  RxInt expandedIndex = (-1).obs;
  void toggleExpansion(int index) => expandedIndex.value = (expandedIndex.value == index ? -1 : index);

  /// Account Section
  var documentsStatus = "Incomplete".obs;

  /// Location Section
  RxBool isMyLocationEnabled = false.obs;
  RxString currentCity = ''.obs;

  Future<void> fetchCurrentLocation() async {
    try {
      // Step 1: Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Disabled',
          'Please enable location services in your device settings.',
        );
        return;
      }

      // Step 2: Check current permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Step 3: Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to get your current city.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Step 4: Permission denied forever → open settings
        Get.snackbar(
          'Permission Denied Forever',
          'Please enable location access from app settings.',
        );
        await Geolocator.openAppSettings();
        return;
      }

      // Step 5: Permission granted → get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Step 6: Reverse geocode to get city name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;

      currentCity.value = (place.postalCode ?? '')
          .replaceAll(RegExp(r'(, )+'), ', ') // clean extra commas
          .replaceAll(RegExp(r'(, )*$'), '') // trim trailing commas
          .trim();

      debugPrint("📍 Current City: ${currentCity.value}");
    } catch (e) {
      debugPrint('❌ Error fetching location: $e');
      Get.snackbar('Error', 'Unable to fetch current location.');
    }
  }

  Future<void> saveLocationPreference(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMyLocationEnabled', val);
  }

  Future<void> loadLocationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    isMyLocationEnabled.value = prefs.getBool('isMyLocationEnabled') ?? false;
  }

  /// Support Section
  var selectedLanguage = "English".obs;

  var userDetails = Rxn<Vendor>(); // vendor model from response
  var isLoading = false.obs;

  /// Change language
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    // Optional: persist in storage
    GetStorage().write("selectedLanguage", lang);
  }

  Future<void> loadNotificationPreference() async {
    Config.isNotificationEnabled.value = await NotificationService.areNotificationsEnabled();
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      bool granted = false;

      if (GetPlatform.isAndroid) {
        final status = await Permission.notification.status;

        if (status.isGranted) {
          granted = true;
        } else if (status.isDenied) {
          final result = await Permission.notification.request();
          granted = result.isGranted;
        } else if (status.isPermanentlyDenied) {
          // Open settings
          await openAppSettings();
          granted = false;
        }
      } else if (GetPlatform.isIOS) {
        final settings = await FirebaseMessaging.instance.getNotificationSettings();

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          granted = true;
        } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
          final newSettings = await FirebaseMessaging.instance.requestPermission();
          granted = newSettings.authorizationStatus == AuthorizationStatus.authorized;
        } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
          // Show dialog to open settings
          Get.snackbar("Permission Denied", "Please enable notifications from Settings.");
          granted = false;
        }
      }

      // Update notification service and config
      await NotificationService.setNotificationEnabled(granted);
      Config.isNotificationEnabled.value = granted;
      log(granted ? "✅ Notifications enabled" : "❌ Notifications OFF");
    } else {
      // Turn OFF directly
      await NotificationService.setNotificationEnabled(false);
      Config.isNotificationEnabled.value = false;
      log("🔕 Notifications disabled by user");
    }
  }

// Format date to readable string (keep your existing if you already have)
  String formatDateTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(isoString).toLocal(); // convert to local time zone
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

// Calculate remaining days between two dates
  int calculateRemainingDays(String startIso, String endIso) {
    try {
      final start = DateTime.parse(startIso);
      final end = DateTime.parse(endIso);
      final now = DateTime.now();

      if (now.isAfter(end)) return 0; // expired
      return end.difference(now).inDays;
    } catch (_) {
      return 0;
    }
  }

// Calculate remaining hours (for when days == 0)
  int calculateRemainingHours(String endIso) {
    try {
      final end = DateTime.parse(endIso);
      final now = DateTime.now();

      if (now.isAfter(end)) return 0; // expired
      return end.difference(now).inHours;
    } catch (_) {
      return 0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadLocationPreference();

    // Load saved language if exists
    getProfileDetails();
    dashboardController.checkSubscriptionStatus();
    final savedLang = GetStorage().read("selectedLanguage");
    if (savedLang != null) {
      selectedLanguage.value = savedLang;
    }
    loadNotificationPreference();
  }

  Future<void> getProfileDetails() async {
    try {
      isLoading.value = true;
      ProfileDetailsModel model = await profileRepository.getProfileDetailsApiCall();

      if (model.status == true && model.vendor != null) {
        userDetails.value = model.vendor; // ✅ assign to the reactive variable
        debugPrint("User fullname: ${model.vendor!.fullname}");
      } else {
        debugPrint("Error fetching profile details");
      }
    } catch (e) {
      debugPrint("Error in getProfileDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Rx<File?> selectedFile = Rx<File?>(null);
  var isDocLoading = false.obs;
  final RxList<DocItem> reUploadDocs = <DocItem>[].obs;

  /// pick from Camera/Gallery/Files
  Future<void> uploadDoc(UploadSource source, String title) async {
    try {
      isDocLoading.value = true;

      final picker = ImagePicker();
      XFile? pickedFile;

      switch (source) {
        case UploadSource.camera:
          pickedFile = await picker.pickImage(source: ImageSource.camera);
          break;
        case UploadSource.gallery:
          pickedFile = await picker.pickImage(source: ImageSource.gallery);
          break;
      }

      if (pickedFile == null) return;

      // Save the picked file to app-local directory and use that path
      final savedPath = await _copyPickedFileToAppDir(pickedFile);
      if (savedPath == null) {
        throw Exception("Failed to save picked file.");
      }

      selectedFile.value = File(savedPath);
      final filePath = savedPath;
      final fileName = pickedFile.name;

      // Update existing DocItem or add a new one
      final existingIndex = reUploadDocs.indexWhere((d) => d.title?.trim() == title.trim());

      if (existingIndex != -1) {
        reUploadDocs[existingIndex] = reUploadDocs[existingIndex].copyWith(
          filePath: filePath,
          fileName: fileName,
          status: DocStatus.verified,
          date: DateTime.now(),
        );
      } else {
        reUploadDocs.add(
          DocItem(
            title: title,
            filePath: filePath,
            fileName: fileName,
            status: DocStatus.verified,
            date: DateTime.now(),
          ),
        );
      }

      // Force notify listeners so UI updates immediately
      reUploadDocs.refresh();
    } catch (e, st) {
      debugPrint('Upload failed: $e\n$st');
      ShowSnackBar.error(message: "Upload failed. Please try again.");
    } finally {
      isDocLoading.value = false;
    }
  }

  /// Copies picked XFile to app documents directory and returns the saved path.
  Future<String?> _copyPickedFileToAppDir(XFile pickedFile) async {
    try {
      final file = File(pickedFile.path);
      if (!await file.exists()) return null;
      final dir = await getApplicationDocumentsDirectory();
      final ext = pickedFile.path.split('.').last;
      final newPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.$ext";
      final newFile = await file.copy(newPath);
      return newFile.path;
    } catch (e, st) {
      debugPrint('Copy picked file failed: $e\n$st');
      return null;
    }
  }

  void openUploadSheet(String title, bool? onlyTakePhoto) {
    Get.bottomSheet(
      UploadSheet(
        onlyTakePhoto: onlyTakePhoto,
        onPick: (src) async {
          Get.back();
          await uploadDoc(src, title);
        },
      ),
      backgroundColor: ColorsForApp.whiteColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Future<bool> reuploadDocumentsApi() async {
    try {
      isLoading.value = true;
      final params = <String, dynamic>{};
      final byteFiles = <String, List<int>>{};

      Future<void> addCompressedByteFile(String key, String? path) async {
        if (path != null && path.isNotEmpty && !path.startsWith('http')) {
          final file = File(path);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            final compressedBytes = await compressImage(bytes);
            byteFiles[key] = compressedBytes;
            print("✅ Added $key (${compressedBytes.length} bytes)");
          } else {
            print("⚠️ File not found: $path");
          }
        }
      }

      await addCompressedByteFile('documentImage', reUploadDocs.firstWhereOrNull((d) => d.title == "Aadhar Card Front")?.filePath);
      await addCompressedByteFile('documentImageBack', reUploadDocs.firstWhereOrNull((d) => d.title == "Aadhar Card Back")?.filePath);
      await addCompressedByteFile('profileImgUrl', reUploadDocs.firstWhereOrNull((d) => d.title == "Selfie Photo")?.filePath);
      await addCompressedByteFile('shopImgUrl', reUploadDocs.firstWhereOrNull((d) => d.title == "Shop Photo")?.filePath);
      await addCompressedByteFile('vehicleImgUrl', reUploadDocs.firstWhereOrNull((d) => d.title == "Vehicle Photo")?.filePath);
      await addCompressedByteFile('licenseImgUrl', reUploadDocs.firstWhereOrNull((d) => d.title == "Driving License")?.filePath);

      if (byteFiles.isEmpty) {
        ShowSnackBar.error(message: "Please reupload at least one document.");
        return false;
      }

      final response = await profileRepository.reuploadDocuments(
        params: params,
        byteFiles: byteFiles,
      );

      if (response.status == true) {
        ShowSnackBar.success(message: "Documents uploaded successfully!");
        await getProfileDetails();
        return true;
      } else {
        ShowSnackBar.error(message: response.message ?? "Upload failed.");
        return false;
      }
    } catch (e, st) {
      debugPrint('❌ Upload error: $e\n$st');
      ShowSnackBar.error(message: e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper: save picked file to local dir
  Future<String?> saveFileToLocalDir(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final dir = await getApplicationDocumentsDirectory();
      final newPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final newFile = await file.copy(newPath);
      return newFile.path;
    }
    return null;
  }

  /// Compress Image before upload
  Future<List<int>> compressImage(Uint8List imageBytes) async {
    final image = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(image, width: 800);
    return img.encodeJpg(resized, quality: 85);
  }

  /// App link share via...
  void shareAppLink() async {
    final info = await PackageInfo.fromPlatform();
    final packageName = info.packageName; // 👈 e.g. com.quickcab.app

    final appLink = 'https://play.google.com/store/apps/details?id=$packageName';
    final message = '''
🚖 *QuickCab App*  

Book your cab rides instantly! 🚗💨  

Download now from Play Store 👇  
$appLink
''';

    Share.share(message);
  }

  // Login  api
  Rx<LogoutModel> logoutModelResponse = LogoutModel().obs;

  Future<bool> logoutAPI({bool isLoaderShow = true}) async {
    try {
      isLoading.value = true;
      LogoutModel logoutModel =
          await profileRepository.logoutApiCall(isLoaderShow: isLoaderShow, params: {'userId': userDetails.value!.id});
      if (logoutModel.status != null && logoutModel.status == true) {
        return true;
      } else {
        isLoading.value = false;
        ShowSnackBar.info(message: logoutModel.message.toString(), title: 'Alert');
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.error(message: e.toString());
      return false;
    }
  }
}
