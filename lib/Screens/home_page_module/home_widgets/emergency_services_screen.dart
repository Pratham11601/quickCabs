import 'package:QuickCab/Screens/home_page_module/home_widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/service_card_controller.dart';

class EmergencyServicesScreen extends StatelessWidget {
  // final String title;
  // final String subtitle;
  // final ServiceType serviceType;

  // EmergencyServicesScreen({
  //   Key? key,
  //   required this.title,
  //   required this.subtitle,
  //   required this.serviceType,
  // }) : super(key: key);

  final EmergencyServicesCardController controller = Get.put(EmergencyServicesCardController());
  String title = Get.arguments[0];
  String subtitle=Get.arguments[1];
  String serviceType=Get.arguments[2];

  EmergencyServicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.h),
        child: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: const Color(0xffF44336),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFE6A37), Color(0xffF44336)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // this is icon if you dont need emoji
                  // Icon(
                  //   Icons.build,
                  //   color: Colors.white,
                  //   size: 22.sp,
                  // ),
                  SizedBox(width: 2.w),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      body:   ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return EmergencyServiceCard(title: "you dont know",
            location:"pune",
            serviceType: "hospital",
          );
        },
      ),
    );
  }
}
