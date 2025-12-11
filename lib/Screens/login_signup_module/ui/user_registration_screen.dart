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

  // Keys for error scroll
  final GlobalKey<FormFieldState> nameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> aadhaarKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> carNumberKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> businessNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> cityNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> pinCodeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> currentAddressKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> emailKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      // ------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------
      appBar: AppBar(
        title: Text(
          "User Registration",
          style: TextHelper.size20.copyWith(fontFamily: boldFont, color: ColorsForApp.whiteColor),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.offAllNamed(Routes.SIGNUP_SCREEN);
            } else {
              Get.offAllNamed(Routes.LOGIN_SCREEN);
            }
          },
        ),
      ),

      // ------------------------------------------------------
      // FIXED BODY (NO INTRINSIC HEIGHT)
      // ------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          child: Form(
            key: userDetailsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFormFields(context),

                SizedBox(height: 12.h), // Space for bottom button
              ],
            ),
          ),
        ),
      ),

      // ------------------------------------------------------
      // BOTTOM BUTTON
      // ------------------------------------------------------
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: SizedBox(
          height: 8.h,
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
                _scrollToFirstError();
              }
            },
            child: Center(
              child: Text(
                "Complete Registration",
                style: TextHelper.size20.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldFont),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // FORM WIDGETS (NO UI CHANGES)
  // ------------------------------------------------------
  Widget buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Text("Personal Information", style: TextHelper.h7.copyWith(fontFamily: boldFont)),
        SizedBox(height: 1.h),

        // FULL NAME
        buildTitle("Full Name"),
        TextFormField(
          key: nameKey,
          controller: controller.fullNameController,
          style: TextHelper.size18.copyWith(fontFamily: regularFont),
          decoration: _input("Enter your full name", Icons.person),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your full name' : null,
        ),

        SizedBox(height: 1.h),

        // GENDER
        buildTitle("Gender"),
        Obx(() => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                errorText: controller.genderError.value ? "Please select Gender" : null,
              ),
              hint: Text("Select Gender", style: TextHelper.size18),
              value: controller.selectedGender.value.isEmpty ? null : controller.selectedGender.value,
              items: controller.genders.map((g) => DropdownMenuItem(value: g, child: Text(g, style: TextHelper.size18))).toList(),
              onChanged: (v) => controller.setGender(v!),
            )),

        SizedBox(height: 1.h),

        // AADHAAR
        buildTitle("Aadhaar Number"),
        TextFormField(
          key: aadhaarKey,
          controller: controller.aadhaarNumberController,
          maxLength: 12,
          keyboardType: TextInputType.number,
          style: TextHelper.size18,
          decoration: _input("Enter your aadhaar number", Icons.credit_card),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter your aadhaar number';
            if (value.length < 12) return 'Please enter correct aadhaar number';
            return null;
          },
        ),

        SizedBox(height: 1.h),

        // CAR NUMBER
        buildTitle("Car Number"),
        TextFormField(
          key: carNumberKey,
          controller: controller.carNumberController,
          textCapitalization: TextCapitalization.characters,
          style: TextHelper.size18,
          decoration: _input("Enter your car number", Icons.credit_card),
          validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your car number' : null,
        ),

        SizedBox(height: 1.h),

        // BUSINESS NAME
        buildTitle("Business Name"),
        TextFormField(
          key: businessNameKey,
          controller: controller.businessNameController,
          style: TextHelper.size18,
          decoration: _input("Enter your business name", Icons.business),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your business name' : null,
        ),

        SizedBox(height: 1.h),

        // CITY NAME
        buildTitle("City Name"),
        TextFormField(
          key: cityNameKey,
          controller: controller.cityNameController,
          style: TextHelper.size18,
          decoration: _input("Enter your city name", Icons.location_city),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your city name' : null,
        ),

        SizedBox(height: 1.h),

        // PINCODE
        buildTitle("Pincode"),
        TextFormField(
          key: pinCodeKey,
          controller: controller.pinCodeController,
          maxLength: 6,
          keyboardType: TextInputType.number,
          style: TextHelper.size18,
          decoration: _input("Enter your pincode", Icons.pin),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your pincode' : null,
        ),

        SizedBox(height: 1.h),

        // CURRENT ADDRESS
        buildTitle("Current Address"),
        TextFormField(
          key: currentAddressKey,
          controller: controller.currentAddressController,
          style: TextHelper.size18,
          decoration: _input("Enter your current address", Icons.place),
          validator: (value) => value == null || value.isEmpty ? 'Please enter your current address' : null,
        ),

        SizedBox(height: 1.h),

        // EMAIL
        buildTitle("Email Address"),
        TextFormField(
          key: emailKey,
          controller: controller.emailController,
          style: TextHelper.size18,
          decoration: _input("Enter your email address", Icons.email),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter your email address';
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Please enter a valid email address';
            return null;
          },
        ),

        SizedBox(height: 3.h),

        // SERVICE TYPES
        buildTitle("Service Types"),
        Text("Select the services you want to provide", style: TextHelper.size18.copyWith(fontFamily: regularFont)),
        SizedBox(height: 1.h),

        Obx(() {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.serviceTypes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 1.5.h,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, i) {
              final type = controller.serviceTypes[i];
              // Observe selectedService for each tile
              final isSelected = controller.selectedService.value == type;

              return GestureDetector(
                onTap: () {
                  // Directly set the reactive value so the UI updates immediately.
                  // Toggle behavior: if already selected, deselect; otherwise select.
                  if (controller.selectedService.value == type) {
                    controller.selectedService.value = '';
                  } else {
                    controller.selectedService.value = type;
                  }

                  // If your controller has side-effects you still want (e.g. analytics),
                  // you can keep calling that method as well:
                  // controller.toggleServiceType?.call(type);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange.shade100.withOpacity(.32) : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      type,
                      style: TextHelper.size18.copyWith(
                        color: isSelected && type == 'None' ? Colors.orange : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        })
      ],
    );
  }

  // ------------------------------------------------------
  // INPUT DECORATION BUILDER (keeps UI same)
  // ------------------------------------------------------
  InputDecoration _input(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: ColorsForApp.primaryDarkColor),
      hintText: hint,
      hintStyle: TextHelper.size18,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
    );
  }

  // ------------------------------------------------------
  // TITLE BUILDER
  // ------------------------------------------------------
  Widget buildTitle(String text) => Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Text(text, style: TextHelper.size19.copyWith(fontFamily: semiBoldFont)),
      );

  // ------------------------------------------------------
  // SCROLL TO FIRST ERROR FIELD
  // ------------------------------------------------------
  void _scrollToFirstError() {
    final keys = [
      nameKey,
      emailKey,
      aadhaarKey,
      carNumberKey,
      businessNameKey,
      cityNameKey,
      pinCodeKey,
      currentAddressKey,
    ];

    for (final key in keys) {
      final state = key.currentState;
      if (state != null && !state.isValid) {
        Scrollable.ensureVisible(
          state.context,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        break;
      }
    }
  }
}
