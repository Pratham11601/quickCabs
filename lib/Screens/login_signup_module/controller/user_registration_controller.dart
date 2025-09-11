import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  TextEditingController businessNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
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

  Future<bool> registerVendor({
    required String email,
    required String phoneNumber,
    required String password,
    required String businessName,
    // required String city,
    required String vendorCat,
    required String currentAddress,
    required String pinCode,
    required String carNumber,
    required int referredBy,
    File? profileImgUrl,
    File? documentImage,
    File? shopImgUrl,
    File? vehicleImgUrl,
  }) async {
    try {
      isLoading.value = true;

      final params = {
        "fullname": fullNameController.text.trim(),
        "phone": phoneNumber.trim(),
        // "aadhaar_number": aadhaarNumber,
        "email": email,
        "password": password,
        "businessName": businessName,
        // "city": city,
        "vendor_cat": vendorCat,
        "currentAddress": currentAddress,
        // "pin_code": pinCode,
        // "carnumber": carNumber,
        "vendor_gender": selectedGender.value,
        "referred_by": referredBy,
        // "profileImgUrl": profileImgUrl,
        // "documentImage": documentImage,
        // "shopImgUrl": shopImgUrl,
        // "vehicleImgUrl": vehicleImgUrl,
      };

      // final files = {
      //   if (profileImgUrl != null) "profileImgUrl": profileImgUrl,
      //   if (documentImage != null) "documentImage": documentImage,
      //   if (shopImgUrl != null) "shopImgUrl": shopImgUrl,
      //   if (vehicleImgUrl != null) "vehicleImgUrl": vehicleImgUrl,
      // };
      final files = <String, File>{};

      // final docImage =
      //     docs.firstWhereOrNull((d) => d.title == "Aadhar Card")?.filePath;
      // if (docImage != null && docImage.isNotEmpty) {
      //   files['documentImage'] = File(docImage);
      // }

      // final profileImg =
      //     docs.firstWhereOrNull((d) => d.title == "Selfie Photo")?.filePath;
      // if (profileImg != null && profileImg.isNotEmpty) {
      //   files['profileImgUrl'] = File(profileImg);
      // }

      // final shopImg =
      //     docs.firstWhereOrNull((d) => d.title == "Shop Photo")?.filePath;
      // if (shopImg != null && shopImg.isNotEmpty) {
      //   files['shopImgUrl'] = File(shopImg);
      // }

      // final vehicleImg =
      //     docs.firstWhereOrNull((d) => d.title == "Vehicle Photo")?.filePath;
      // if (vehicleImg != null && vehicleImg.isNotEmpty) {
      //   files['vehicleImgUrl'] = File(vehicleImg);
      // }
      void addFileIfExists(String key, String? path) {
        if (path != null && path.isNotEmpty) {
          final file = File(path);
          if (file.existsSync()) files[key] = file;
        }
      }

      addFileIfExists(
        'documentImage',
        docs.firstWhereOrNull((d) => d.title == "Aadhar Card")?.filePath,
      );
      addFileIfExists(
        'profileImgUrl',
        docs.firstWhereOrNull((d) => d.title == "Selfie Photo")?.filePath,
      );
      addFileIfExists(
        'shopImgUrl',
        docs.firstWhereOrNull((d) => d.title == "Shop Photo")?.filePath,
      );
      addFileIfExists(
        'vehicleImgUrl',
        docs.firstWhereOrNull((d) => d.title == "Vehicle Photo")?.filePath,
      );

      final response = await authRepository.registerVendor(
        params: params,
        files: files.isEmpty ? null : files,
      );

      if (response.status == true) {
        ShowSnackBar.success(message: "Registration successful!");
        isLoading.value = false;
        return true;
      } else {
        ShowSnackBar.error(message: response.message ?? "Registration failed.");
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
      isLoading.value = false;
      return false;
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
    // baaki sab types me default ek hi document
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

  /// pick from Camera/Gallery/Files
  Future<void> uploadDoc(int index, UploadSource source) async {
    try {
      String? path;
      String? name;

      switch (source) {
        case UploadSource.camera:
          final picked =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (picked == null) return;
          path = picked.path;
          name = File(picked.path).uri.pathSegments.last;
          break;

        case UploadSource.gallery:
          final picked =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (picked == null) return;
          path = picked.path;
          name = File(picked.path).uri.pathSegments.last;
          break;

        // case UploadSource.files:
        //   final result = await FilePicker.platform.pickFiles(
        //     type: FileType.custom,
        //     allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        //   );
        //   if (result == null) return;
        //   path = result.files.single.path!;
        //   name = result.files.single.name;
        //   break;
      }

      final item = docs[index];
      item.filePath = path;
      item.fileName = name;
      item.status = DocStatus.verified;
      item.date = DateTime.now();

      docs[index] = item; // Trigger UI update
      recomputeProgress();
    } catch (e) {
      debugPrint("Upload failed: $e");
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
