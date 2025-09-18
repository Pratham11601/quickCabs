import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/routes.dart';
import '../../../widgets/common_widgets.dart';
import '../controller/login_controller.dart';

/// Root login screen with app-level theme setup
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Cabs Driver',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const DriverLoginPage(),
    );
  }

  Future<void> _requestPermissions() async {
    // ✅ Location
    final locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      debugPrint("✅ Location granted");
    } else if (locationStatus.isDenied) {
      debugPrint("❌ Location denied");
    } else if (locationStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    // ✅ Notifications
    if (GetPlatform.isAndroid) {
      final notifStatus = await Permission.notification.request();
      if (notifStatus.isGranted) {
        debugPrint("✅ Notifications granted (Android)");
      } else {
        debugPrint("❌ Notifications denied (Android)");
      }
    } else if (GetPlatform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint("✅ Notifications granted (iOS)");
      } else {
        debugPrint("❌ Notifications denied (iOS)");
      }
    }
  }
}

/// Main login page with phone or OTP screen toggle
class DriverLoginPage extends StatelessWidget {
  const DriverLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          return LoadingOverlay(
            isLoading: loginController.isLoading.value,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Header(),
                  const PhoneNumberContainer(),

                  // Section: Why Join
                  const WhyJoinSection(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Phone number input card with button
class PhoneNumberContainer extends StatelessWidget {
  const PhoneNumberContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: boxDecoration(),
      child: Form(
        key: loginController.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Enter Mobile Number',
                textAlign: TextAlign.center, style: TextHelper.h4.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
            const SizedBox(height: 10),
            Text("We'll send you an OTP to verify your\nnumber",
                textAlign: TextAlign.center, style: TextHelper.size18.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
            const SizedBox(height: 12),
            const PhoneTextField(),
            const SizedBox(height: 12),
            const PasswordTextField(),

            /// Remember Me Checkbox (uses Obx to react to changes)
            Obx(() => Row(
                  children: [
                    Checkbox(
                      value: loginController.rememberMe.value,
                      onChanged: (val) {
                        loginController.rememberMe.value = val ?? false;
                      },
                    ),
                    Text(
                      "Remember Me",
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                    ),
                  ],
                )),
            const SizedBox(height: 12),
            // Send OTP button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (loginController.isValidNumber.value) {
                        if (loginController.loginFormKey.currentState!.validate()) {
                          bool result = await loginController.loginAPI();
                          if (result) {
                            Get.offAllNamed(Routes.DASHBOARD_PAGE);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: loginController.isValidNumber.value ? ColorsForApp.primaryColor : ColorsForApp.cta,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextHelper.h6.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: semiBoldFont,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_right_alt_rounded,
                          size: 35,
                          color: ColorsForApp.whiteColor,
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 15),

            // Divider with "New to Quick Cabs?"
            Row(
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "New to Quick Cabs?",
                    style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                  ),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),

            const SizedBox(height: 15),

            // Create New Account Button
            OutlinedButton(
              onPressed: () {
                // Navigate to Sign Up page
                Get.toNamed(Routes.SIGNUP_SCREEN);
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.hovered)) {
                      return ColorsForApp.subTitleColor; // background on hover
                    }
                    return Colors.white; // default background
                  },
                ),
                side: WidgetStateProperty.all(
                  BorderSide(color: ColorsForApp.blackColor.withValues(alpha: 0.2)),
                ),
              ),
              child: Text("Create New Account", style: TextHelper.h7.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom phone input with country code + validation border
class PhoneTextField extends StatelessWidget {
  const PhoneTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find();
    return Obx(() => OutlinedField(
          isFocused: loginController.isPhoneFocused.value,
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.call_outlined, color: ColorsForApp.primaryColor, size: 20), // smaller to match
              const SizedBox(width: 10),
              Text(
                '+91',
                style: TextHelper.size19.copyWith(
                  color: ColorsForApp.blackColor,
                  fontFamily: semiBoldFont,
                ),
              ),
              const SizedBox(width: 10),
              Container(width: 1, height: 24, color: Colors.grey.shade300),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: loginController.phoneController,
                  focusNode: loginController.phoneFocusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counterText: '',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, // keeps it comfortable, not too tall/short
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Enter 10-digit mobile number',
                    hintStyle: TextHelper.size19.copyWith(color: ColorsForApp.subtle),
                  ),
                  style: TextHelper.size19.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: semiBoldFont,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find();
    return Obx(() => OutlinedField(
          isFocused: loginController.isPasswordFocused.value,
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.password, color: ColorsForApp.primaryColor, size: 20), // smaller to match
              const SizedBox(width: 10),
              Container(width: 1, height: 24, color: Colors.grey.shade300),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => TextField(
                    controller: loginController.passwordController,
                    focusNode: loginController.passwordFocusNode,
                    obscureText: !loginController.isPasswordVisible.value, // hide if false
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      counterText: '',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, // keeps it comfortable, not too tall/short
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Enter password',
                      hintStyle: TextHelper.size19.copyWith(color: ColorsForApp.subtle),
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                          color: ColorsForApp.subtle,
                        ),
                        onPressed: () {
                          loginController.isPasswordVisible.toggle();
                        },
                      ),
                    ),
                    style: TextHelper.size19.copyWith(
                      color: ColorsForApp.blackColor,
                      fontFamily: semiBoldFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
