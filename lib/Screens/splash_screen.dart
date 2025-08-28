import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/controller/app_controller.dart';

import '../controller/network_controller.dart';
import '../generated/assets.dart';
import 'login_signup_module/model/login_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  NetworkController networkController =
      Get.put(NetworkController(), permanent: true);
  AppController appController = Get.find();
  // LocationController locationController =
  //     Get.put(LocationController(), permanent: true);
  LoginModel loginModel = LoginModel();
  late AnimationController animationController;
  double containerHeight = 150;
  double containerWidth = 150;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.iconsLogo,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: animationController.value,
                          child: child,
                        );
                      },
                      child: Image.asset(Assets.iconsLogo),
                    ),
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
