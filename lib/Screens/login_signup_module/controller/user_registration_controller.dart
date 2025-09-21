import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../../api/api_manager.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/snackbar.dart';
import '../../document_verification_module/model/docItemModel.dart';
import '../../document_verification_module/model/upload_source.dart';
import '../../document_verification_module/ui/uploadSheet.dart'
    show UploadSheet;
import '../repository/auth_repository.dart';

class UserRegistrationController extends GetxController {
  AuthRepository authRepository = AuthRepository(APIManager());

  final RxList<String> genders =
      <String>['Male', 'Female', 'Other', 'Prefer Not to say'].obs;
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

  // Future<bool> userRegisration({required String password,vendorCat}) async {
  //   isLoading.value = true;
  //   try {
  //     UserRegistrationModel model =
  //         await authRepository.userRegistrationApiCall(params: {
  //       "fullname":fullName.value.trim(),
  //       "phone": phoneNumber.value.trim(),
  //       "aadhaar_number": "1234-5678-9012",
  //       "password": password,
  //       "vendor_cat": vendorCat,
  //       "vendor_gender": selectedGender.value,
  //     });
  //     if (model.status == true) {
  //       ShowSnackBar.success(message: model.message!);
  //       isLoading.value = false;

  //       return true;
  //     } else {
  //       ShowSnackBar.info(message: model.message!);
  //       isLoading.value = false;
  //       return false;
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     ShowSnackBar.info(message: e.toString());
  //     return false;
  //   }
  // }

  // Future<bool> registerVendor({
  //   required String email,
  //   required String phoneNumber,
  //   required String password,
  //   required String businessName,
  //   required String vendorCat,
  //   required String currentAddress,
  //   required String pinCode,
  //   required String carNumber,
  //   required int referredBy,
  //   File? profileImgUrl,
  //   File? documentImage,
  //   File? shopImgUrl,
  //   File? vehicleImgUrl,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final params = {
  //       "fullname": fullNameController.text.trim(),
  //       "phone": phoneNumber.trim(),
  //       // "aadhaar_number": aadhaarNumber,
  //       "email": email,
  //       "password": password,
  //       "businessName": businessName,
  //       // "city": city,
  //       "vendor_cat": vendorCat,
  //       "currentAddress": currentAddress,
  //       // "pin_code": pinCode,
  //       // "carnumber": carNumber,
  //       "vendor_gender": selectedGender.value,
  //       "referred_by": referredBy,
  //       // "profileImgUrl": profileImgUrl,
  //       // "documentImage": documentImage,
  //       // "shopImgUrl": shopImgUrl,
  //       // "vehicleImgUrl": vehicleImgUrl,
  //     };
  //
  //     final files = <String, File>{};
  //
  //     void addFileIfExists(String key, String? path) {
  //       if (path != null && path.isNotEmpty) {
  //         final file = File(path);
  //         if (file.existsSync()) files[key] = file;
  //       }
  //     }
  //
  //     addFileIfExists(
  //       'documentImage',
  //       docs.firstWhereOrNull((d) => d.title == "Aadhar Card")?.filePath,
  //     );
  //     addFileIfExists(
  //       'profileImgUrl',
  //       docs.firstWhereOrNull((d) => d.title == "Selfie Photo")?.filePath,
  //     );
  //     addFileIfExists(
  //       'shopImgUrl',
  //       docs.firstWhereOrNull((d) => d.title == "Shop Photo")?.filePath,
  //     );
  //     addFileIfExists(
  //       'vehicleImgUrl',
  //       docs.firstWhereOrNull((d) => d.title == "Vehicle Photo")?.filePath,
  //     );
  //     // addFileIfExists(
  //     //   'licenseImage',
  //     //   docs.firstWhereOrNull((d) => d.title == "Driving License")?.filePath,
  //     // );
  //
  //     final response = await authRepository.registerVendor(
  //       params: params,
  //       files: files.isEmpty ? null : files,
  //     );
  //
  //     if (response.status == true) {
  //       ShowSnackBar.success(message: "Registration successful!");
  //       isLoading.value = false;
  //       return true;
  //     } else {
  //       ShowSnackBar.error(message: response.message ?? "Registration failed.");
  //       isLoading.value = false;
  //       return false;
  //     }
  //   } catch (e) {
  //     ShowSnackBar.error(message: e.toString());
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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
          final bytes = await File(path).readAsBytes();
          final compressedBytes = await compressImage(bytes);
          byteFiles[key] = compressedBytes;
        }
      }

      await addCompressedByteFile(
        'documentImage',
        docs.firstWhereOrNull((d) => d.title == "Aadhar Card")?.filePath,
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

      // 3️⃣ Debug prints
      print("📌 Params:");
      params.forEach((k, v) => print("   $k: $v"));

      print("📌 Byte files:");
      byteFiles.forEach((k, v) => print("   $k: ${v.length} bytes"));

      // 4️⃣ Call repository with byteFiles
      final response = await authRepository.registerVendor(
        params: params,
        byteFiles: byteFiles.isEmpty ? null : byteFiles,
      );

      // 5️⃣ Handle response
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
  final RxList<String> serviceTypes = <String>[
    'Cab',
    'Towing',
    'Repairing',
    'Puncture',
    'Drivers',
    'Fuel',
    'Restaurant',
    'Hospital',
    'Car Sell'
  ].obs;

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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhaar photo',
        required: true,
      ),
      DocItem(
        title: 'Vehicle RC',
        subtitle: 'Vehicle registration certificate',
        required: false,
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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhaar photo',
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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhar photo',
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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhar photo',
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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhar photo',
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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhar photo',
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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhar photo',
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
        title: 'Aadhar Card',
        subtitle: 'Valid aadhar photo',
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

      final selectedImageBytes = await selectedFile.value!.readAsBytes();
      final compressedImgBytes = await compressImage(selectedImageBytes);

      // Use pickedFile.path directly instead of savedPath
      final filePath = pickedFile.path;
      final fileName =
          pickedFile.name; // requires image_picker 1.0.0+ (supports .name)

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
    }
  }

  void replaceDoc(int index, bool isOnlysSelfie) =>
      openUploadSheet(index, isOnlysSelfie);

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
    final doneRequired =
        docs.where((d) => d.required && d.status != DocStatus.empty).length;
    progress.value = totalRequired == 0 ? 0 : doneRequired / totalRequired;
  }

  int remainingRequiredCount() {
    final totalRequired = docs.where((d) => d.required).length;
    final doneRequired =
        docs.where((d) => d.required && d.status != DocStatus.empty).length;
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
