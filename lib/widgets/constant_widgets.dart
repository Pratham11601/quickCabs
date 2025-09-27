import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../generated/assets.dart';
import '../routes/routes.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

SizedBox height(double h) => SizedBox(height: h);
SizedBox width(double w) => SizedBox(width: w);

// Most commonly used widgets

// Scaffold
class CustomScaffold extends StatelessWidget {
  final AppBar? appBar;
  final List<Widget>? appBarActions;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final bool? centerTitle;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Widget? leading;
  final bool? resizeToAvoidBottomInset;
  final bool showLeadingIcon;
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final void Function()? onBack;
  final Widget? bottomSheet;
  final Color? appBarBackground;
  final double? drawerEdgeDragWidth;

  final Widget? stackedHeader;

  final double extendedHeight;

  CustomScaffold({
    super.key,
    AppBar? appBar,
    this.appBarActions,
    this.body,
    this.bottomNavigationBar,
    this.centerTitle,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.drawer,
    this.floatingActionButton,
    this.leading,
    this.resizeToAvoidBottomInset,
    this.showLeadingIcon = false,
    this.title,
    this.titleStyle,
    this.backgroundColor,
    this.onBack,
    this.bottomSheet,
    this.appBarBackground,
    this.drawerEdgeDragWidth,
    this.stackedHeader,
    this.extendedHeight = 0,
  })  : assert(title == null || appBar == null),
        appBar = appBar ??
            (title != null
                ? AppBar(
                    automaticallyImplyLeading: false,
                    leading: leading != null || showLeadingIcon
                        ? leading ??
                            IconButton(
                              onPressed: onBack ?? Get.back,
                              icon: leading ?? Icon(CupertinoIcons.back, size: 16.sp),
                            )
                        : null,
                    actions: [...?appBarActions, width(3.w)],
                    centerTitle: centerTitle,
                    backgroundColor: appBarBackground ?? Colors.transparent,
                    title: Text(
                      title,
                      style: titleStyle ?? TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                    ),
                  )
                : null);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      // appBar: appBar,
      backgroundColor: backgroundColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (appBar != null)
            Container(
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.only(bottom: 1.h),
              height: statusBarHeight + appBar!.preferredSize.height + extendedHeight + 3.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                    color: Colors.grey,
                    blurRadius: 3,
                  )
                ],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: SvgPicture.asset(
                Assets.imagesAppBarBg,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surfaceBright, BlendMode.screen),
              ),
            ),
          Column(
            children: [
              if (appBar != null)
                Column(
                  children: [
                    height(3.h),
                    appBar!,
                    if (stackedHeader != null) stackedHeader!,
                  ],
                ),
              if (body != null) Flexible(child: body!),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawer: drawer, drawerEdgeDragWidth: drawerEdgeDragWidth,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: extendBody ?? false,
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
    );
  }
}

//Custom Switch Widget
class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 16.w,
        height: 3.2.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: value ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              left: value ? 40.0 : 0.0,
              right: value ? 0.0 : 40.0,
              child: Padding(
                padding: EdgeInsets.only(top: 0.38.h),
                child: Container(
                  width: 3.w,
                  height: 2.5.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.tertiaryFixedDim,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: value ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text(
                    value ? 'Offline' : 'Online',
                    style: TextHelper.size14.copyWith(color: Theme.of(context).colorScheme.tertiaryFixedDim),
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

//Dotted Line
class DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final Axis axis;

  DottedLinePainter({
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.color = Colors.black87,
    required this.axis, // Default to horizontal
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    if (axis == Axis.horizontal) {
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
        startX += dashWidth + dashSpace;
      }
    } else if (axis == Axis.vertical) {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Exit dailog
showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
        title: Text(
          'Exit',
          style: TextHelper.h7.copyWith(fontFamily: boldFont, color: ColorsForApp.blackColor),
        ),
        content: Text(
          'Are you sure you want to exit?',
          style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Get.back();
                },
                splashColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
                highlightColor: ColorsForApp.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100),
                child: Text(
                  'Cancel',
                  style: TextHelper.size19.copyWith(
                    fontFamily: regularFont,
                    color: ColorsForApp.blackColor,
                  ),
                ),
              ),
              width(4.w),
              InkWell(
                onTap: () async {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                splashColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
                highlightColor: ColorsForApp.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100),
                child: Text(
                  'Confirm',
                  style: TextHelper.size19.copyWith(
                    fontFamily: regularFont,
                    color: ColorsForApp.primaryDarkColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

// Common message dialog
showCommonMessageDialog(BuildContext context, String title, String message, GestureTapCallback onClick) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            title,
            style: TextHelper.h7.copyWith(
              fontFamily: boldFont,
            ),
          ),
          content: Text(
            message,
            style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor.withValues(alpha: 0.7), fontFamily: regularFont),
          ),
          actions: [
            InkWell(
              onTap: onClick,
              splashColor: ColorsForApp.primaryColor.withValues(alpha: 0.1),
              highlightColor: ColorsForApp.primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100),
              child: Text(
                'Proceed',
                style: TextHelper.size18.copyWith(
                  fontFamily: semiBoldFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
} //

// Common Dialog For Subscription
showSubscriptionAlertDialog(BuildContext context, String title, String message, GestureTapCallback onClick) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextHelper.h7.copyWith(color: ColorsForApp.blackColor, fontFamily: boldFont),
      ),
      content: Text(
        message,
        style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.SUBSCRIPTION);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsForApp.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Subscribe",
                  style: TextHelper.size20.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: TextHelper.size20.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
