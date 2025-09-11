import 'package:QuickCab/Screens/home_page_module/home_widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/common_widgets.dart';
import '../controller/service_card_controller.dart';

class EmergencyServicesScreen extends StatelessWidget {
  String title = Get.arguments[0];
  String serviceType = Get.arguments[2];
  final EmergencyServicesCardController controller = Get.put(EmergencyServicesCardController(category: Get.arguments[0]));
  EmergencyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // height of AppBar
        child: Obx(() => CustomAppBar(
              title: title,
              subtitle: "${controller.totalVendors.value} services available",
            )),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.vendors.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isLoading.value &&
                controller.isMoreDataAvailable.value &&
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              controller.loadMore();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: controller.vendors.length + (controller.isMoreDataAvailable.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.vendors.length) {
                final vendor = controller.vendors[index];
                return EmergencyServiceCard(
                  title: vendor.businessName ?? vendor.fullname ?? "Unknown",
                  location: vendor.city ?? "Unknown",
                  serviceType: vendor.vendorCat ?? "Unknown",
                );
              } else {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
