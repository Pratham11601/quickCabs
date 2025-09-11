import 'package:QuickCab/Screens/home_page_module/home_widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/common_widgets.dart';
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
  String subtitle = Get.arguments[1];
  String serviceType = Get.arguments[2];

  EmergencyServicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        subtitle: subtitle,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return EmergencyServiceCard(
            title: "you dont know",
            location: "pune",
            serviceType: "hospital",
          );
        },
      ),
    );
  }
}
