import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/routes/routes.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:sizer/sizer.dart';
import '../../document_verification_module/controller/document_verification_controller.dart';
import '../controller/user_registration_controller.dart';

class UserRegistrationScreen extends StatelessWidget {
  UserRegistrationScreen({super.key});
  final UserRegistrationController controller =
      Get.put(UserRegistrationController());
  final DocVerifyController docController = Get.put(DocVerifyController());
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
        leading: Icon(Icons.arrow_back, color: Colors.white),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Text("Personal Information",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
              SizedBox(height: 3.h),
              Text("Full Name",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 1.h),
              Obx(() => TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter your full name",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14.sp),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9)),
                      errorText: controller.fullNameError.value
                          ? "Full Name is required"
                          : null,
                    ),
                    onChanged: (value) => controller.fullName.value = value,
                  )),
              SizedBox(height: 2.h),
              Text("Gender",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
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
              SizedBox(height: 4.h),
              Text("Service Types",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              SizedBox(height: 0.6.h),
              Text(
                "Select the services you want to provide",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 1.h),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docController.serviceTypes.length,
                    itemBuilder: (context, index) {
                      final type = docController.serviceTypes[index];
                      return Obx(() {
                        final isSelected =
                            docController.selectedService.value == type;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.5.h),
                          child: GestureDetector(
                            onTap: () => docController.toggleServiceType(type),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsForApp.gradientTop,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
                ),
                onPressed: () {
                  if (controller.validateInputs()) {
                    Get.toNamed(Routes.DOCUMENT_VERIFICATION_PAGE);
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
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
