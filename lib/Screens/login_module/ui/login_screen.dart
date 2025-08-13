import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/login_module/controller/login_controller.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:own_idea/utils/text_styles.dart';

import '../../../generated/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Cabs Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5A3D),
          primary: ColorsForApp.primaryColor,
          onPrimary: Colors.white,
          surface: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          hintStyle: const TextStyle(color: Color(0xFF8E8E93), fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E5EA), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 2),
          ),
        ),
      ),
      home: const DriverLoginPage(),
    );
  }
}

//Login screen
class DriverLoginPage extends StatelessWidget {
  const DriverLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero gradient header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ColorsForApp.gradientTop, ColorsForApp.gradientBottom],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.4), // White circle background for logo
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 6),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.iconsLogo,
                            width: 80,
                            height: 80,
                            fit: BoxFit.fill,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text('Welcome Driver!',
                        textAlign: TextAlign.center,
                        style: TextHelper.h2.copyWith(
                          color: ColorsForApp.whiteColor,
                          fontFamily: semiBoldFont,
                        )),
                    const SizedBox(height: 5),
                    Text(
                      'Join Quick Cabs Driver Network',
                      textAlign: TextAlign.center,
                      style: TextHelper.h6.copyWith(
                        color: ColorsForApp.whiteColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                  ],
                ),
              ),
              // Card
              Obx(() {
                return loginController.showOtpScreen.value
                    ? OtpVerifyContainer(
                        phoneNumber: loginController.phoneController.text, // pass entered number
                        onChangeNumber: loginController.changeMobileNumber,
                      )
                    : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                        decoration: BoxDecoration(
                          color: ColorsForApp.whiteColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ColorsForApp.cardStroke, width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 10,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Enter Mobile Number',
                                textAlign: TextAlign.center,
                                style: TextHelper.h4.copyWith(
                                  color: ColorsForApp.headline,
                                  fontFamily: semiBoldFont,
                                )),
                            const SizedBox(height: 10),
                            Text("We'll send you an OTP to verify your\nnumber",
                                textAlign: TextAlign.center,
                                style: TextHelper.size18.copyWith(
                                  color: ColorsForApp.headline,
                                  fontFamily: semiBoldFont,
                                )),
                            PhoneTextField(),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: loginController.isValidNumber.value ? ColorsForApp.primaryColor : ColorsForApp.cta,
                                      foregroundColor: loginController.isValidNumber.value ? Colors.white : Colors.grey.shade600,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: loginController.isValidNumber.value ? () => loginController.sendOtp() : null,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Send OTP',
                                            style: TextHelper.h6.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_right_alt_rounded,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              }),

              // Why join
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Why Join Quick Cabs?',
                      textAlign: TextAlign.center, style: TextHelper.h3.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
                ),
              ),
              BenefitTile(
                icon: Icons.trending_up_rounded,
                iconColor: ColorsForApp.primaryColor,
                title: 'Maximize Earnings',
                subtitle: 'Share rides and earn more together',
              ),
              BenefitTile(
                icon: Icons.groups_rounded,
                iconColor: ColorsForApp.colorBlue,
                title: 'Driver Network',
                subtitle: 'Connect with nearby professional drivers',
              ),
              BenefitTile(
                icon: Icons.verified_rounded,
                iconColor: ColorsForApp.colorVerifyGreen,
                title: 'Verified Platform',
                subtitle: 'Secure and trusted driver community',
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextHelper.size19.copyWith(color: ColorsForApp.subtle, height: 1.5),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                          text: 'Terms of Service',
                          style: TextHelper.size19
                              .copyWith(color: ColorsForApp.primaryColor, decoration: TextDecoration.underline, fontFamily: semiBoldFont)),
                      const TextSpan(text: ' and '),
                      TextSpan(
                          text: 'Privacy Policy',
                          style: TextHelper.size19
                              .copyWith(color: ColorsForApp.primaryColor, decoration: TextDecoration.underline, fontFamily: semiBoldFont)),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({super.key});

  @override
  State<PhoneTextField> createState() => PhoneTextFieldState();
}

class PhoneTextFieldState extends State<PhoneTextField> {
  final LoginController loginController = Get.put(LoginController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: // Phone input field with reactive border color
          // Phone input
          Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: loginController.isFocused.value
                        ? ColorsForApp.cta // Change to your primary color
                        : Colors.grey.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(Icons.call_outlined, color: ColorsForApp.primaryColor, size: 24),
                    const SizedBox(width: 10),
                    Text('+91', style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                    const SizedBox(width: 10),
                    Container(width: 1, height: 28, color: Colors.grey),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: loginController.phoneController,
                        focusNode: loginController.phoneFocusNode,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
                        decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Enter 10-digit mobile num',
                          hintStyle: TextHelper.size20.copyWith(
                            color: ColorsForApp.subtle,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 18),
                        ),
                      ),
                    )
                  ],
                ),
              )),
    );
  }
}

class BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const BenefitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsForApp.sectionStroke),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextHelper.size20.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextHelper.size18.copyWith(color: ColorsForApp.subtle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Otp screen
class OtpVerifyContainer extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onChangeNumber;

  OtpVerifyContainer({
    super.key,
    required this.phoneNumber,
    required this.onChangeNumber,
  });

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorsForApp.cardStroke, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user, color: ColorsForApp.primaryColor, size: 50),
          const SizedBox(height: 15),
          Text("Verify OTP",
              style: TextHelper.h4.copyWith(
                color: ColorsForApp.headline,
                fontFamily: semiBoldFont,
              )),
          const SizedBox(height: 8),
          Text("Enter the 6-digit code sent to",
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.headline,
                fontFamily: semiBoldFont,
              )),
          const SizedBox(height: 4),
          Text("+91 $phoneNumber",
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.headline,
                fontFamily: semiBoldFont,
              )),
          const SizedBox(height: 20),

          // OTP Input
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: loginController.isFocused.value
                      ? ColorsForApp.cta // Change to your primary color
                      : Colors.grey.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: loginController.otpController,
                focusNode: loginController.otpFocusNode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextHelper.h5.copyWith(color: ColorsForApp.blackColor, letterSpacing: 4, fontFamily: semiBoldFont),
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Verify Button
          Obx(() => ElevatedButton(
                onPressed: loginController.isOtpValid.value ? loginController.verifyOtp : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: loginController.isOtpValid.value ? ColorsForApp.primaryColor : ColorsForApp.cta,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Verify & Continue", style: TextHelper.h6.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              )),

          const SizedBox(height: 15),

          // Change Mobile Number
          GestureDetector(
            onTap: onChangeNumber,
            child:
                Text("Change mobile number", style: TextHelper.size19.copyWith(color: ColorsForApp.primaryColor, fontFamily: semiBoldFont)),
          ),

          const SizedBox(height: 15),

          // Resend OTP
          Obx(() => loginController.resendTimer.value > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 5),
                    Text("Resend OTP in ${loginController.resendTimer.value}s", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                )
              : GestureDetector(
                  onTap: loginController.resendOtp,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 16, color: ColorsForApp.blackColor),
                      const SizedBox(width: 5),
                      Text("Resend OTP", style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
