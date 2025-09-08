import 'package:get/get.dart';


import '../../../api/api_manager.dart';
import '../../../widgets/snackbar.dart';
import '../model/user_registration_model.dart';
import '../repository/auth_repository.dart';

class UserRegistrationController extends GetxController {
  AuthRepository authRepository = AuthRepository(APIManager());

  final RxList<String> genders =
      <String>['Male', 'Female', 'Other', 'Prefer Not to say'].obs;
  final RxString selectedGender = ''.obs;
  final RxString fullName = ''.obs;
  final RxString phoneNumber = ''.obs;

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  final RxList<String> languages = <String>['English', 'Hindi', 'Marathi'].obs;
  final RxString selectedLanguage = 'English'.obs;
  final RxBool isLanguageDropdownVisible = false.obs;
  final RxBool fullNameError = false.obs;
  final RxBool genderError = false.obs;
  final RxBool isLoading = false.obs;
  

  void setLanguage(String lang) {
    selectedLanguage.value = lang;
    isLanguageDropdownVisible.value = false;
  }

  void toggleLanguageDropdown() {
    isLanguageDropdownVisible.value = !isLanguageDropdownVisible.value;
  }

  bool validateInputs() {
    bool isValid = true;

    if (fullName.value.trim().isEmpty) {
      fullNameError.value = true;
      isValid = false;
    } else {
      fullNameError.value = false;
    }

    if (selectedGender.value.isEmpty) {
      genderError.value = true;
      isValid = false;
    } else {
      genderError.value = false;
    }

    return isValid;
  }

  Future<bool> userRegisration({required String password,vendorCat}) async {
    isLoading.value = true;
    try {
      UserRegistrationModel model =
          await authRepository.userRegistrationApiCall(params: {
        "fullname":fullName.value.trim(),
        "phone": phoneNumber.value.trim(),
        "aadhaar_number": "1234-5678-9012",
        "password": password,
        "vendor_cat": vendorCat,
        "vendor_gender": selectedGender.value,
      });
      if (model.status == true) {
        ShowSnackBar.success(message: model.message!);
        isLoading.value = false;

        return true;
      } else {
        ShowSnackBar.info(message: model.message!);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.info(message: e.toString());
      return false;
    }
  }
}
