import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/snackbar.dart';
import '../controller/user_registration_controller.dart';

class UserRegistrationScreen extends StatelessWidget {
  UserRegistrationScreen({super.key});
  final UserRegistrationController controller = Get.put(UserRegistrationController());
  final GlobalKey<FormState> userDetailsFormKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  // 🔑 Keys for each field
  final GlobalKey<FormFieldState> aadhaarKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> carNumberKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> pinCodeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> nameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> businessNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> cityNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> currentAddressKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("User Registration", style: TextHelper.size20.copyWith(fontFamily: boldFont, color: ColorsForApp.whiteColor)),
        centerTitle: true,
        backgroundColor: ColorsForApp.gradientTop,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFE6A37), Color(0xffF44336)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.offAllNamed(Routes.SIGNUP_SCREEN); // Fallback if opened directly
            } else {
              Get.offAllNamed(Routes.LOGIN_SCREEN); // Fallback if opened directly
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // optional improvement
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
            child: Form(
              key: userDetailsFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text("Personal Information",
                      style: TextHelper.h7.copyWith(
                        fontFamily: boldFont,
                      )),
                  SizedBox(height: 1.h),
                  Text("Full Name",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: nameKey,
                    controller: controller.fullNameController,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your full name",
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      errorStyle: TextStyle(fontSize: 13.sp),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text("Gender",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  Obx(() => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                          errorText: controller.genderError.value ? "Please select Gender" : null,
                        ),
                        hint: Text(
                          "Select Gender",
                          style: TextHelper.size18.copyWith(
                            fontFamily: regularFont,
                          ),
                        ),
                        value: controller.selectedGender.value.isEmpty ? null : controller.selectedGender.value,
                        items: controller.genders
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(
                                    gender,
                                    style: TextHelper.size18.copyWith(
                                      fontFamily: regularFont,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) controller.setGender(value);
                        },
                      )),
                  SizedBox(height: 1.h),
                  Text("Aadhaar Number",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: aadhaarKey,
                    controller: controller.aadhaarNumberController,
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your aadhaar number",
                      errorStyle: TextHelper.size16.copyWith(
                        fontFamily: regularFont,
                      ),
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your aadhaar number';
                      } else if (value.length < 12) {
                        return 'Please enter correct aadhaar number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text("Car Number",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: carNumberKey,
                    controller: controller.carNumberController,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your car number",
                      errorStyle: TextHelper.size16.copyWith(
                        fontFamily: regularFont,
                      ),
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    validator: (value) {
                      final trimmedValue = value?.trimRight();

                      // final vehicleRegExp = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{4}$');

                      if (trimmedValue == null || trimmedValue.isEmpty) {
                        return 'Please enter your car number';
                      }
                      // else if (!vehicleRegExp.hasMatch(trimmedValue.toUpperCase())) {
                      //   return 'Please enter a valid car number';
                      // }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text("Business Name",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: businessNameKey,
                    controller: controller.businessNameController,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.business,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your business name",
                      errorStyle: TextHelper.size16.copyWith(
                        fontFamily: regularFont,
                      ),
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text("City Name",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: cityNameKey,
                    controller: controller.cityNameController,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.business,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your city name",
                      errorStyle: TextHelper.size16.copyWith(
                        fontFamily: regularFont,
                      ),
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text("Pincode",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: pinCodeKey,
                    controller: controller.pinCodeController,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.business,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your pincode",
                      errorStyle: TextHelper.size16.copyWith(
                        fontFamily: regularFont,
                      ),
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your pincode';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text("Current Address",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: currentAddressKey,
                    controller: controller.currentAddressController,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.place,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your current address",
                      errorStyle: TextHelper.size16.copyWith(
                        fontFamily: semiBoldFont,
                      ),
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    inputFormatters: [
                      // Limit input to 100 characters
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.h),
                  Text("Email Address",
                      style: TextHelper.size19.copyWith(
                        fontFamily: semiBoldFont,
                      )),
                  SizedBox(height: 1.h),
                  TextFormField(
                    key: emailKey,
                    controller: controller.emailController,
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextHelper.size16.copyWith(
                        fontFamily: regularFont,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: ColorsForApp.primaryDarkColor,
                      ),
                      hintText: "Enter your email address",
                      hintStyle: TextHelper.size18.copyWith(
                        fontFamily: regularFont,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    validator: (value) {
                      if (controller.emailController.text.isEmpty) {
                        return 'Please enter your email address';
                      }
                      // Simple email regex
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(controller.emailController.text)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 4.h),
                  Text("Service Types",
                      style: TextHelper.h7.copyWith(
                        fontFamily: boldFont,
                      )),
                  SizedBox(height: 0.6.h),
                  Text(
                    "Select the services you want to provide",
                    style: TextHelper.size18.copyWith(
                      fontFamily: regularFont,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Obx(() => GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.serviceTypes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 1.5.h,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final type = controller.serviceTypes[index];
                          return Obx(() {
                            final isSelected = controller.selectedService.value == type;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 1.5.h),
                              child: GestureDetector(
                                onTap: () => controller.toggleServiceType(type),
                                child: Container(
                                  key: ValueKey(type),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.orange.shade100.withOpacity(0.32) : Colors.white,
                                    border: Border.all(
                                      color: isSelected ? Colors.orange : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: ListTile(
                                    title: Center(
                                      child: Text(type,
                                          style: TextHelper.size18.copyWith(
                                              fontFamily: regularFont, color: isSelected && type == 'None' ? Colors.orange : Colors.black)),
                                    ),
                                    // trailing: Icon(Icons.chevron_right, color: Colors.grey),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      )),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 8.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsForApp.gradientTop,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
            ),
            onPressed: () {
              if (userDetailsFormKey.currentState!.validate()) {
                if (controller.selectedGender.value.isEmpty) {
                  ShowSnackBar.info(message: 'Please select your gender');
                } else if (controller.selectedService.value.isEmpty) {
                  ShowSnackBar.info(message: 'Please select service type');
                } else {
                  Get.toNamed(Routes.DOCUMENT_VERIFICATION_PAGE);
                }
              } else {
                // find which field failed
                final fieldKeys = [
                  nameKey,
                  emailKey,
                  aadhaarKey,
                  carNumberKey,
                  businessNameKey,
                  cityNameKey,
                  pinCodeKey,
                  currentAddressKey,
                ];

                for (final key in fieldKeys) {
                  final currentState = key.currentState;
                  if (currentState != null && !currentState.isValid) {
                    _scrollToError(key);
                    break; // stop after first error
                  }
                }
                // add more checks as needed
              }
            },
            child: Center(
              child: Text("Complete Registration", style: TextHelper.size20.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldFont)),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToError(GlobalKey<FormFieldState> fieldKey) {
    final context = fieldKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
