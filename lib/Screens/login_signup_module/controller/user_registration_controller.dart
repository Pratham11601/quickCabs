import 'package:get/get.dart';

class UserRegistrationController extends GetxController {
  final RxList<String> genders = <String>['Male', 'Female', 'Other','Prefer Not to say'].obs;
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

  void setLanguage(String lang) {
    selectedLanguage.value = lang;
    isLanguageDropdownVisible.value = false;
  }

  void toggleLanguageDropdown() {
    isLanguageDropdownVisible.value = !isLanguageDropdownVisible.value;
  }

  final RxList<String> serviceTypes = <String>[
  'None', 'Cab', 'Towing', 'Repairing', 'Puncture', 'Drivers', 'Fuel', 'Restaurant', 'Hospital'
  ].obs;

  // Selected services - observable RxList
  final RxList<String> selectedServices = <String>[].obs;

  // Toggle service selection
  void toggleServiceType(String type) {
    print("Toggling service type: $type");
    if (type == 'None') {
      selectedServices.clear();
      selectedServices.add('None');
    } else {
      if (selectedServices.contains('None')) {
        selectedServices.remove('None');
      }
      if (selectedServices.contains(type)) {
        selectedServices.remove(type);
      } else {
        selectedServices.add(type);
      }
    }
    print("Selected services now: $selectedServices");
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

}
