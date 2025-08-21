import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/routes/routes.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:own_idea/utils/text_styles.dart';
import 'package:own_idea/widgets/common_widgets.dart';

import '../controller/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<SignupController>();
    final paddingH = horizontalPadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SignUpHeader(onBack: Get.back)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: SignupCard(c: signupController),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(paddingH, 12, paddingH, 24),
              sliver: SliverToBoxAdapter(child: WhyJoinSection()),
            ),
          ],
        ),
      ),
    );
  }
}

/// The card that contains the form fields + password rules + CTA + Sign-in link
class SignupCard extends StatelessWidget {
  const SignupCard({super.key, required this.c});
  final SignupController c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorsForApp.cardStroke),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 14, offset: Offset(0, 10))],
      ),
      child: Form(
        key: c.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top icon & title
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // const Icon(Icons.person_add_alt_1_rounded, color: ColorsForApp.primaryColor, size: 40),
                  // const SizedBox(height: 8),
                  Text('Create Account', style: TextHelper.h3.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
                  const SizedBox(height: 6),
                  Text('Fill in your details to get started',
                      style: TextHelper.size19.copyWith(
                        color: ColorsForApp.blackColor,
                      ),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mobile
            Text('Mobile Number', style: TextHelper.size19.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
            const SizedBox(height: 8),
            Obx(() => OutlinedField(
                  isFocused: c.isPhoneFocused.value,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.call_outlined, color: ColorsForApp.primaryColor),
                      const SizedBox(width: 10),
                      Text('+91', style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                      const SizedBox(width: 10),
                      Container(width: 1, height: 24, color: Colors.grey.shade300),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: c.phoneCtrl,
                          focusNode: c.phoneFocus,
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
                            hintText: 'Enter 10-digit mobile num',
                            hintStyle: TextHelper.size19.copyWith(color: ColorsForApp.subtle),
                          ),
                          style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),

            // Password
            Text('Password', style: TextHelper.size19.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
            const SizedBox(height: 8),
            Obx(() => OutlinedField(
                  isFocused: c.isPassFocused.value,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.lock_outline, color: ColorsForApp.primaryColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: c.passCtrl,
                          focusNode: c.passFocus,
                          obscureText: c.isPassObscured.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, // keeps it comfortable, not too tall/short
                            ),
                            hintText: 'Enter password (min. 6 chars)',
                            hintStyle: TextHelper.size19.copyWith(color: ColorsForApp.subtle),
                          ),
                          style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor),
                        ),
                      ),
                      IconButton(
                        onPressed: () => c.isPassObscured.toggle(),
                        icon: Icon(
                          c.isPassObscured.value ? Icons.visibility_off : Icons.visibility,
                          color: ColorsForApp.subtle,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 15),

            // Confirm
            Text('Confirm Password', style: TextHelper.size19.copyWith(color: ColorsForApp.headline, fontFamily: semiBoldFont)),
            const SizedBox(height: 8),
            Obx(() => OutlinedField(
                  isFocused: c.isConfirmFocused.value,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.lock_outline, color: ColorsForApp.primaryColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: c.confirmCtrl,
                          focusNode: c.confirmFocus,
                          obscureText: c.isConfirmObscured.value,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, // keeps it comfortable, not too tall/short
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Confirm your password',
                            hintStyle: TextHelper.size19.copyWith(color: ColorsForApp.subtle),
                          ),
                          style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor),
                        ),
                      ),
                      IconButton(
                        onPressed: () => c.isConfirmObscured.toggle(),
                        icon: Icon(
                          c.isConfirmObscured.value ? Icons.visibility_off : Icons.visibility,
                          color: ColorsForApp.subtle,
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 15),

            // Password requirements box
            InfoCard(
              title: 'Password Requirements:',
              bullets: const [
                'At least 6 characters long',
                'Must contain at least one letter and one number',
                'Use a strong, unique password',
              ],
            ),
            const SizedBox(height: 15),

            // Create Account CTA
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: c.canSubmit ? c.submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.canSubmit ? ColorsForApp.primaryColor : ColorsForApp.cta,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: c.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Create Account',
                                  style: TextHelper.h6.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
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

            const SizedBox(height: 14),

            // Already have an account
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Already have an account?', style: TextHelper.size19.copyWith(color: ColorsForApp.subtle)),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => Get.offAllNamed(Routes.LOGIN_SCREEN),
                    child: Text('Sign In',
                        style: TextHelper.size19.copyWith(
                          color: ColorsForApp.primaryColor,
                          fontFamily: semiBoldFont,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
