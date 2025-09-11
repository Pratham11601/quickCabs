import 'package:QuickCab/Screens/login_signup_module/controller/user_registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/landing_page/controller/dashboard_controller.dart';
import '../generated/assets.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

/// Utility: Calculates responsive horizontal padding
/// - >=1000px: centers content with ~720px column
/// - >=600px: 32px padding
/// - else: 16px padding
///
double horizontalPadding(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w >= 1000) return (w - 720) / 2; // center a 720px-ish column on web/tablet
  if (w >= 600) return 32;
  return 16;
}

/// Login screen header with gradient background, logo, and welcome text
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            child: Image.asset(Assets.iconsLogo, width: 80, height: 80, fit: BoxFit.fill),
          ),
          const SizedBox(height: 15),
          Text('Welcome Driver!',
              textAlign: TextAlign.center, style: TextHelper.h2.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
          const SizedBox(height: 5),
          Text('Join Quick Cabs Driver Network',
              textAlign: TextAlign.center, style: TextHelper.h6.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
        ],
      ),
    );
  }
}

/// Reusable blue info card with title and bullet points
class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.bullets});
  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD3E6FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextHelper.size18.copyWith(
                color: const Color(0xFF1F6FEB),
                fontFamily: semiBoldFont,
              )),
          const SizedBox(height: 8),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(
                      b,
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.headline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section showing benefits of joining Quick Cabs (list of BenefitTile widgets)
class WhyJoinSection extends StatelessWidget {
  const WhyJoinSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 12),
          child: Align(
            alignment: Alignment.center,
            child: Text('Why Join Quick Cabs?',
                textAlign: TextAlign.center, style: TextHelper.h5.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
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
        SizedBox(height: 14),
      ],
    );
  }
}

/// Reusable info tile widget with icon, title, and subtitle
class BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const BenefitTile({super.key, required this.icon, required this.title, required this.subtitle, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsForApp.sectionStroke),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 40),
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

/// Global theme for login/signup pages with gradient and input styles
ThemeData buildTheme() {
  return ThemeData(
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
  );
}

/// Sign-up header with gradient, back button, logo, and title text
class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorsForApp.gradientTop, ColorsForApp.gradientBottom],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            child: Image.asset(Assets.iconsLogo, width: 30, height: 30, fit: BoxFit.fill),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Join Quick Cabs', style: TextHelper.h3.copyWith(color: Colors.white, fontFamily: semiBoldFont)),
                const SizedBox(height: 2),
                Text('Create your driver account',
                    style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapper widget for text fields with animated border color on focus
class OutlinedField extends StatelessWidget {
  const OutlinedField({super.key, required this.child, required this.isFocused});
  final Widget child;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFocused ? ColorsForApp.cta : Colors.grey.withValues(alpha: 0.3),
          width: 1.5,
        ),
        // boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 2, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: child,
    );
  }
}

/// Help box for Document Verification page (guidelines and tips)
class DocHelpBox extends StatelessWidget {
  const DocHelpBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: ColorsForApp.helpBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsForApp.helpBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Need Help?', style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
          SizedBox(height: 10),
          Bullet('Documents should be clear and readable'),
          Bullet('Supported formats: JPG, PNG, PDF'),
          Bullet('Maximum file size: 5MB per document'),
          Bullet('Verification typically takes 24–48 hours'),
        ],
      ),
    );
  }
}

/// Single bullet point text line used inside DocHelpBox
class Bullet extends StatelessWidget {
  const Bullet(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Text('•  ', style: TextStyle(fontSize: 18, height: 1.2)),
          Expanded(child: Text(text, style: TextHelper.size18.copyWith(height: 1.2, color: ColorsForApp.title))),
        ],
      ),
    );
  }
}

/// Header for Document Verification page with progress indicator
class DocHeader extends StatelessWidget {
  const DocHeader({super.key, required this.controller});
  final UserRegistrationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorsForApp.gradientTop, ColorsForApp.gradientBottom],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: back + title + logo + progress pill
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: Get.back,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Document Verification',
                          style: TextHelper.h6.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final pct = (controller.progress.value * 100).round();
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorsForApp.pill,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.white.withValues(alpha: .4)),
                    ),
                    child: Text('$pct% \nComplete',
                        textAlign: TextAlign.center,
                        style: TextHelper.size16.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
            // Subtitle with icon and description
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.description_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Document Upload',
                        style: TextHelper.size20.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Complete required documents to\ncontinue',
                        style: TextHelper.size17.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 14),

            // Progress bar and step labels
            Obx(() => Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: controller.progress.value.clamp(0, 1),
                        backgroundColor: ColorsForApp.whiteColor.withValues(alpha: .25),
                        valueColor: AlwaysStoppedAnimation<Color>(ColorsForApp.whiteColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        dotLabel('Driving', left: true),
                        const Spacer(),
                        dotLabel('Commercial', left: false),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  /// Small circular dot with label used in progress indicator
  Widget dotLabel(String text, {required bool left}) {
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: .25),
            border: Border.all(color: Colors.white.withValues(alpha: .7), width: 2),
          ),
        ),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

/// Small pill-style chip used for statuses (e.g., Verified, Optional, Required)
class Chip extends StatelessWidget {
  const Chip({super.key, required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: .6)),
      ),
      child: Text(text, style: TextHelper.size16.copyWith(color: color, fontFamily: semiBoldFont)),
    );
  }
}

/// Action links for previewing, deleting, or replacing documents during verification
class ActionLink extends StatelessWidget {
  const ActionLink({super.key, required this.icon, required this.color, required this.label, required this.onTap});
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextHelper.size19.copyWith(color: color, fontFamily: semiBoldFont)),
          ],
        ),
      ),
    );
  }
}

/// A reusable custom success/info dialog.
/// You can pass in [title], [message], [icon], [buttonText], and [onConfirm].
/// Uses your design system (TextHelper, ColorsForApp, fonts).
class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String buttonText;
  final VoidCallback onConfirm;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_rounded, // default icon
    this.buttonText = 'OK', // default button text
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Icon Section (e.g., Success, Info, Warning)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorsForApp.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: ColorsForApp.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextHelper.h4.copyWith(
                color: ColorsForApp.headline,
                fontFamily: semiBoldFont,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.subtle,
                fontFamily: regularFont,
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsForApp.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: TextHelper.h6.copyWith(
                    color: Colors.white,
                    fontFamily: semiBoldFont,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Helper method to show the dialog anywhere in your app.
/// Just call this method with the required parameters.
void showAppDialog({
  required String title,
  required String message,
  IconData icon = Icons.info_rounded,
  String buttonText = 'OK',
  VoidCallback? onConfirm,
}) {
  Get.dialog(
    AppDialog(
      title: title,
      message: message,
      icon: icon,
      buttonText: buttonText,
      onConfirm: onConfirm ?? () => Get.back(),
    ),
    barrierDismissible: false, // force user to acknowledge
  );
}

/// Helper Widget for dashboard bottom navigation bar
Widget buildNavItem({
  required IconData icon,
  required String label,
  required int index,
  required DashboardController controller,
}) {
  final isSelected = controller.currentIndex.value == index;
  return GestureDetector(
    onTap: () => controller.changeTab(index),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 26,
          color: isSelected ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
        ),
        const SizedBox(height: 5),
        Text(label,
            style: TextHelper.size17.copyWith(
                color: isSelected ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
                fontFamily: isSelected ? semiBoldFont : regularFont)),
      ],
    ),
  );
}

/// Common Box Decoration
BoxDecoration boxDecoration() {
  return BoxDecoration(
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
  );
}

/// Custom App Bar for all screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool showBack;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle = "",
    this.showBack = true,
    this.actions,
  });
  @override
  Size get preferredSize => const Size.fromHeight(80); // AppBar height

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsForApp.gradientTop,
              ColorsForApp.gradientBottom,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            if (showBack)
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            if (showBack) const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // important to avoid taking full height
                children: [
                  Text(
                    title,
                    style: TextHelper.h5.copyWith(
                      color: Colors.white,
                      fontFamily: semiBoldFont,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextHelper.size18.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                    ),
                ],
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}

/// Common url launcher

class UrlLauncherHelper {
  /// Opens a given [url] in-app WebView (fallback: external browser)
  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withAlpha(80),
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                size: 50,
                color: ColorsForApp.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
