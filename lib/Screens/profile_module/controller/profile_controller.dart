import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:QuickCab/Screens/profile_module/model/profile_details_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../api/api_manager.dart';
import '../../../notificaton/notifications_services.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/config.dart';
import '../../../widgets/snackbar.dart';
import '../../document_verification_module/model/docItemModel.dart';
import '../../document_verification_module/model/upload_source.dart';
import '../../document_verification_module/ui/uploadSheet.dart';
import '../repository/profile_repository.dart';

  class ProfileController extends GetxController {
  ProfileRepository profileRepository = ProfileRepository(APIManager());

  /// Account Section
  var documentsStatus = "Incomplete".obs;

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
    Config.isNotificationEnabled.value =
        await NotificationService.areNotificationsEnabled();
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
        final settings =
            await FirebaseMessaging.instance.getNotificationSettings();

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          granted = true;
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.notDetermined) {
          final newSettings =
              await FirebaseMessaging.instance.requestPermission();
          granted =
              newSettings.authorizationStatus == AuthorizationStatus.authorized;
        } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
          // Show dialog to open settings
          Get.snackbar("Permission Denied",
              "Please enable notifications from Settings.");
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

  @override
  void onInit() {
    super.onInit();
    // Load saved language if exists
    getProfileDetails();
    final savedLang = GetStorage().read("selectedLanguage");
    if (savedLang != null) {
      selectedLanguage.value = savedLang;
    }
    loadNotificationPreference();
  }

  Future<void> getProfileDetails() async {
    try {
      isLoading.value = true;
      ProfileDetailsModel model =
          await profileRepository.getProfileDetailsApiCall();

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
  Future<void> uploadDoc(int index, UploadSource source) async {
    try {
      isDocLoading.value = true;

      final picker = ImagePicker();
      final pickedFile;

      switch (source) {
        case UploadSource.camera:
          pickedFile = await picker.pickImage(source: ImageSource.camera);
          break;
        case UploadSource.gallery:
          pickedFile = await picker.pickImage(source: ImageSource.gallery);
          break;
      }

      if (pickedFile == null) return;

      selectedFile.value = File(pickedFile.path);

      if (selectedFile.value == null) {
        throw Exception("No picture selected.");
      }

      // Use pickedFile.path directly instead of savedPath
      final filePath = pickedFile.path;
      final fileName =
          pickedFile.name; // requires image_picker 1.0.0+ (supports .name)

      // ✅ Update your model safely
      reUploadDocs[index] = reUploadDocs[index].copyWith(
        filePath: filePath,
        fileName: fileName,
        status: DocStatus.verified,
        date: DateTime.now(),
      );
    } catch (e, st) {
      debugPrint('Upload failed: $e\n$st');
    } finally {
      isDocLoading.value = false;
    }
  }

  void openUploadSheet(int index, bool? onlyTakePhoto) {
    Get.bottomSheet(
      UploadSheet(
        onlyTakePhoto: onlyTakePhoto,
        onPick: (src) async {
          Get.back();
          await uploadDoc(index, src);
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

      // 1️⃣ Prepare text params
      final Map<String, dynamic> params = {

      };

      // 2️⃣ Prepare byteFiles map
      final byteFiles = <String, List<int>>{};

      /// Helper: compress image and add to byteFiles
      Future<void> addCompressedByteFile(String key, String? path) async {
        if (path != null && path.isNotEmpty) {
          final localPath =
              await saveFileToLocalDir(path); // ✅ always permanent
          if (localPath != null) {
            final file = File(localPath);
            if (await file.exists()) {
              final bytes = await file.readAsBytes();
              final compressedBytes = await compressImage(bytes);
              byteFiles[key] = compressedBytes;
            }
          }
        }
      }

      // 3️⃣ Add all docs
      await addCompressedByteFile(
        'documentImage',
        reUploadDocs
            .firstWhereOrNull((d) => d.title == "Aadhar Card Front")?.filePath,
      );
      await addCompressedByteFile(
        'documentImageBack',
        reUploadDocs
            .firstWhereOrNull((d) => d.title == "Aadhar Card Back")?.filePath,
      );
      await addCompressedByteFile(
        'profileImgUrl',
        reUploadDocs
            .firstWhereOrNull((d) => d.title == "Selfie Photo")?.filePath,
      );
      await addCompressedByteFile(
        'shopImgUrl',
        reUploadDocs.firstWhereOrNull((d) => d.title == "Shop Photo")?.filePath,
      );
      await addCompressedByteFile(
        'vehicleImgUrl',
        reUploadDocs
            .firstWhereOrNull((d) => d.title == "Vehicle Photo")?.filePath,
      );
      await addCompressedByteFile(
        'licenseImgUrl',
        reUploadDocs
            .firstWhereOrNull((d) => d.title == "Driving License")?.filePath,
      );

      // 4️⃣ Debug prints
      print("📌 Params:");
      params.forEach((k, v) => print("   $k: $v"));

      print("📌 Byte files:");
      byteFiles.forEach((k, v) => print("   $k: ${v.length} bytes"));

      // 5️⃣ Call repository with byteFiles
      final response = await profileRepository.reuploadDocuments(
        params: params,
        byteFiles: byteFiles.isEmpty ? null : byteFiles,
      );

      // 6️⃣ Handle response
      if (response.status == true) {
        ShowSnackBar.success(message: "Images uploaded successful!");
        return true;
      } else {
        ShowSnackBar.error(message: response.message ?? "upload failed.");
        return false;
      }
    } catch (e, st) {
      debugPrint('"Images uploaded error: $e\n$st');
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
      final newPath =
          "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
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

    final appLink =
        'https://play.google.com/store/apps/details?id=$packageName';
    final message = '''
🚖 *QuickCab App*  

Book your cab rides instantly! 🚗💨  

Download now from Play Store 👇  
$appLink
''';

    Share.share(message);
  }
}
