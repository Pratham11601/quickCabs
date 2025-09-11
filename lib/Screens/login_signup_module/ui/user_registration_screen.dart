import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/snackbar.dart';
import '../controller/user_registration_controller.dart';

class UserRegistrationScreen extends StatelessWidget {
  UserRegistrationScreen({super.key});
  final UserRegistrationController controller =
      Get.put(UserRegistrationController());
  final GlobalKey<FormState> userDetailsFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("User Registration",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
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
        leading: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: Obx(() => Stack(
                  children: [
                    TextButton.icon(
                      onPressed: () => controller.toggleLanguageDropdown(),
                      icon: Icon(Icons.language, color: Colors.white),
                      label: Text(controller.selectedLanguage.value,
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red[400]!,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    if (controller.isLanguageDropdownVisible.value)
                      Positioned(
                        right: 0,
                        top: 40,
                        child: Material(
                          color: Colors.white,
                          elevation: 6,
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: 32.w,
                            child: ListView(
                              shrinkWrap: true,
                              children: controller.languages
                                  .map((lang) => ListTile(
                                        title: Text(lang),
                                        selected:
                                            controller.selectedLanguage.value ==
                                                lang,
                                        selectedTileColor: Colors.red.shade50,
                                        onTap: () =>
                                            controller.setLanguage(lang),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                  ],
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          child: Form(
            key: userDetailsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text("Personal Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.sp)),
                SizedBox(height: 3.h),
                Text("Full Name",
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: controller.fullNameController,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter your full name",
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
                    errorStyle: TextStyle(fontSize: 13.sp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                Text("Gender",
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 1.h),
                Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9)),
                        errorText: controller.genderError.value
                            ? "Please select Gender"
                            : null,
                      ),
                      hint: Text("Select Gender"),
                      value: controller.selectedGender.value.isEmpty
                          ? null
                          : controller.selectedGender.value,
                      items: controller.genders
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) controller.setGender(value);
                      },
                    )),
                SizedBox(height: 2.h),
                Text("Business Name",
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: controller.businessNameController,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.business),
                    hintText: "Enter your business name",
                    errorStyle: TextStyle(fontSize: 13.sp),
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your business name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                Text("Current Address",
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: controller.currentAddressController,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.place),
                    hintText: "Enter your current address",
                    errorStyle: TextStyle(fontSize: 13.sp),
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9)),
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
                SizedBox(height: 2.h),
                Text("Email Address",
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: controller.emailController,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: 13.sp),
                    prefixIcon: Icon(Icons.email),
                    hintText: "Enter your email address",
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  validator: (value) {
                    if (controller.emailController.text.isEmpty) {
                      return 'Please enter your email address';
                    }
                    // Simple email regex
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(controller.emailController.text)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                Text("Service Types",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp)),
                SizedBox(height: 0.6.h),
                Text(
                  "Select the services you want to provide",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 1.h),
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.serviceTypes.length,
                      itemBuilder: (context, index) {
                        final type = controller.serviceTypes[index];
                        return Obx(() {
                          final isSelected =
                              controller.selectedService.value == type;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: GestureDetector(
                              onTap: () => controller.toggleServiceType(type),
                              child: Container(
                                key: ValueKey(type),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.orange.shade100.withOpacity(0.32)
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: ListTile(
                                  title: Text(
                                    type,
                                    style: TextStyle(
                                      color: isSelected && type == 'None'
                                          ? Colors.orange
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  trailing: Icon(Icons.chevron_right,
                                      color: Colors.grey),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
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
      bottomNavigationBar: SizedBox(
        height: 8.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsForApp.gradientTop,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
              }
            },
            child: Center(
              child: Text("Complete Registration",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
