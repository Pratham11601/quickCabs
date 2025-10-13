import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../api/api_manager.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/snackbar.dart';
import '../../document_verification_module/model/docItemModel.dart';
import '../../document_verification_module/model/upload_source.dart';
import '../../document_verification_module/ui/uploadSheet.dart' show UploadSheet;
import '../repository/auth_repository.dart';

class UserRegistrationController extends GetxController {
  AuthRepository authRepository = AuthRepository(APIManager());

  final RxList<String> genders = <String>['Male', 'Female', 'Other', 'Prefer Not to say'].obs;
  final RxString selectedGender = ''.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController aadhaarNumberController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  final RxList<String> languages = <String>['English', 'Hindi', 'Marathi'].obs;
  final RxString selectedLanguage = 'English'.obs;
  final RxBool isLanguageDropdownVisible = false.obs;
  final RxBool genderError = false.obs;
  final RxBool isLoading = false.obs;

  void setLanguage(String lang) {
    selectedLanguage.value = lang;
    isLanguageDropdownVisible.value = false;
  }

  void toggleLanguageDropdown() {
    isLanguageDropdownVisible.value = !isLanguageDropdownVisible.value;
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

  Future<bool> registerVendor({
    required String email,
    required String phoneNumber,
    required String password,
    required String businessName,
    required String vendorCat,
    required String currentAddress,
    required int referredBy,
  }) async {
    try {
      isLoading.value = true;

      // 1️⃣ Prepare text params
      final params = {
        "fullname": fullNameController.text.trim(),
        "aadhaar_number": aadhaarNumberController.text.trim(),
        "phone": phoneNumber.trim(),
        "email": email,
        "pin_code": pinCodeController.text.trim(),
        "carnumber": carNumberController.text.trim(),
        "city": cityNameController.text.trim(),
        "password": password,
        "businessName": businessName,
        "vendor_cat": vendorCat,
        "currentAddress": currentAddress,
        "vendor_gender": selectedGender.value,
        "referred_by": referredBy,
      };

      // 2️⃣ Prepare byteFiles map
      final byteFiles = <String, List<int>>{};

      /// Helper: compress image and add to byteFiles
      Future<void> addCompressedByteFile(String key, String? path) async {
        if (path != null && path.isNotEmpty) {
          final localPath = await saveFileToLocalDir(path); // ✅ always permanent
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
        docs.firstWhereOrNull((d) => d.title == "Aadhar Card Front")?.filePath,
      );
      await addCompressedByteFile(
        'documentImageBack',
        docs.firstWhereOrNull((d) => d.title == "Aadhar Card Back")?.filePath,
      );
      await addCompressedByteFile(
        'profileImgUrl',
        docs.firstWhereOrNull((d) => d.title == "Selfie Photo")?.filePath,
      );
      await addCompressedByteFile(
        'shopImgUrl',
        docs.firstWhereOrNull((d) => d.title == "Shop Photo")?.filePath,
      );
      await addCompressedByteFile(
        'vehicleImgUrl',
        docs.firstWhereOrNull((d) => d.title == "Vehicle Photo")?.filePath,
      );
      await addCompressedByteFile(
        'licenseImgUrl',
        docs.firstWhereOrNull((d) => d.title == "Driving License")?.filePath,
      );

      // 4️⃣ Debug prints
      print("📌 Params:");
      params.forEach((k, v) => print("   $k: $v"));

      print("📌 Byte files:");
      byteFiles.forEach((k, v) => print("   $k: ${v.length} bytes"));

      // 5️⃣ Call repository with byteFiles
      final response = await authRepository.registerVendor(
        params: params,
        byteFiles: byteFiles.isEmpty ? null : byteFiles,
      );

      // 6️⃣ Handle response
      if (response.status == true) {
        ShowSnackBar.success(message: "Registration successful!");
        return true;
      } else {
        ShowSnackBar.error(message: response.message ?? "Registration failed.");
        return false;
      }
    } catch (e, st) {
      debugPrint('Vendor registration error: $e\n$st');
      ShowSnackBar.error(message: e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

// Service types
  final RxList<String> serviceTypes =
      <String>['Cab', 'Towing', 'Repairing', 'Puncture', 'Drivers', 'Fuel', 'Restaurant', 'Hospital', 'Car Sell'].obs;

// Selected service - only one at a time
  final RxString selectedService = ''.obs;

// Toggle service selection
  void toggleServiceType(String type) {
    print("Toggling service type: $type");
    selectedService.value = type; // sirf ek service rakhega
    docs.assignAll(serviceDocs[type] ?? []);
    recomputeProgress();

    print("Selected service now: ${selectedService.value}");
  }

  final RxString leadBy = ''.obs; // dropdown

  // Dynamic document requirements for each service type
  final Map<String, List<DocItem>> serviceDocs = {
    'Cab': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Driving License',
        subtitle: 'Valid commercial driving license',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhaar front photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Vehicle Photo',
        subtitle: 'Clear photo of your vehicle',
        required: true,
      ),
    ],
    'Drivers': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhaar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Driving License',
        subtitle: 'Valid driving license',
        required: true,
      ),
    ],
    'Puncture': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Shop Act License',
        subtitle: 'Valid shop act license',
        required: true,
      ),
    ],
    'Fuel': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Shop Act License',
        subtitle: 'Valid shop act license',
        required: true,
      ),
    ],
    'Towing': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
    'Repairing': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
    'Restaurant': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
    'Hospital': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Front',
        subtitle: 'Valid aadhar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
    'Car Sell': [
      DocItem(
        title: 'Selfie Photo',
        subtitle: 'Clear selfie photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card',
        subtitle: 'Valid aadhar photo',
        required: true,
      ),
      DocItem(
        title: 'Aadhar Card Back',
        subtitle: 'Valid aadhaar back photo',
        required: true,
      ),
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
  };

  final RxList<DocItem> docs = <DocItem>[].obs;

  // void loadDocsForService(String service) {
  //   selectedService.value = service;
  //   docs.assignAll(serviceDocs[service] ?? []);
  //   recomputeProgress();
  // }
  var isDocLoading = false.obs;

  RxDouble progress = 0.0.obs; // 0.0 -> 1.0

  // File? selectedFile;
  Rx<File?> selectedFile = Rx<File?>(null);

  String? fileName;

  /// Compress Image before upload
  Future<List<int>> compressImage(Uint8List imageBytes) async {
    final image = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(image, width: 800);
    return img.encodeJpg(resized, quality: 85);
  }

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
      final fileName = pickedFile.name; // requires image_picker 1.0.0+ (supports .name)

      // ✅ Update your model safely
      docs[index] = docs[index].copyWith(
        filePath: filePath,
        fileName: fileName,
        status: DocStatus.verified,
        date: DateTime.now(),
      );

      recomputeProgress();
    } catch (e, st) {
      debugPrint('Upload failed: $e\n$st');
    } finally {
      isDocLoading.value = false;
    }
  }

  /// Per-document uploading flags so UI can show loader only on that doc card
  final Map<int, RxBool> docUploading = {};

  void replaceDoc(int index, bool isOnlysSelfie) => openUploadSheet(index, isOnlysSelfie);

  void deleteDoc(int index) {
    final i = docs[index];
    i.filePath = null;
    i.fileName = null;
    i.status = DocStatus.empty;
    i.date = null;
    docs[index] = i;
    recomputeProgress();
  }

  void recomputeProgress() {
    final totalRequired = docs.where((d) => d.required).length;
    final doneRequired = docs.where((d) => d.required && d.status != DocStatus.empty).length;
    progress.value = totalRequired == 0 ? 0 : doneRequired / totalRequired;
  }

  int remainingRequiredCount() {
    final totalRequired = docs.where((d) => d.required).length;
    final doneRequired = docs.where((d) => d.required && d.status != DocStatus.empty).length;
    return (totalRequired - doneRequired).clamp(0, totalRequired);
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
}
