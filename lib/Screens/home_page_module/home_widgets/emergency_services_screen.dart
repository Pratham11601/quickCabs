import 'package:QuickCab/Screens/home_page_module/home_widgets/service_card.dart';
import 'package:QuickCab/widgets/no_data_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/config.dart';
import '../../../widgets/common_widgets.dart';
import '../controller/service_card_controller.dart';

class EmergencyServicesScreen extends StatelessWidget {
  String title = Get.arguments[0];
  String serviceType = Get.arguments[2];
  EmergencyServicesCardController controller = Get.put(EmergencyServicesCardController(category: Get.arguments[0]));
  EmergencyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(25.h), // height of AppBar
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
          child: controller.vendors.isEmpty
              ? Center(
                  child: NoDataFoundScreen(title: "NO $title Found", subTitle: ""),
                )
              : ListView.builder(
                  itemCount: controller.vendors.length + (controller.isMoreDataAvailable.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.vendors.length) {
                      final vendor = controller.vendors[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        child: EmergencyServiceCard(
                          title: vendor.businessName ?? vendor.fullname ?? "-",
                          address: vendor.currentAddress ?? "-",
                          city: vendor.city ?? "-",
                          pincode: vendor.pinCode ?? "-",
                          serviceType: vendor.vendorCat ?? "-",
                          profileImage: "${Config.baseUrl}${vendor.profileImgUrl}",
                          carNumber: vendor.carnumber ?? "-",
                          phone: vendor.phone ?? "-",
                        ),
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
