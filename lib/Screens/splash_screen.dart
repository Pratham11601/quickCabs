import 'dart:async';

import 'package:QuickCab/controller/app_controller.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/network_controller.dart';
import '../generated/assets.dart';
import '../routes/routes.dart';
import 'login_signup_module/model/login_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final NetworkController networkController = Get.put(NetworkController(), permanent: true);
  final AppController appController = Get.find();
  final LoginModel loginModel = LoginModel();

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    // ✅ Setup animation
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    // ✅ Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      // Example: go to login screen
      Get.offAllNamed(Routes.LOGIN_SCREEN);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorsForApp.gradientTop, ColorsForApp.gradientBottom],
          ),
        ),
        child: Center(
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.5 + animationController.value * 0.5, // smooth zoom
                    child: child,
                  );
                },
                child: Image.asset(Assets.iconsLogo),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
