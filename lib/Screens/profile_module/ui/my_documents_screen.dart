import 'package:QuickCab/Screens/profile_module/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';
import '../profile_widgets/document_card.dart';

class MyDocumentsPage extends StatelessWidget {
  const MyDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX Controller instance
    final ProfileController controller = Get.find<ProfileController>();

    // Fetch profile details when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProfileDetails();
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Documents",
        subtitle: "My uploaded documents",
      ),
      body: Obx(() {
        // Show loader while fetching data
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // If no vendor data available
        final vendor = controller.userDetails.value;
        if (vendor == null) {
          return const Center(child: Text("No documents found"));
        }

        // ✅ Build documents list dynamically (only if URLs exist)
        final docs = <Map<String, dynamic>>[];

        if (vendor.documentImgUrl?.isNotEmpty ?? false) {
          docs.add({
            "name": "Aadhar Card",
            "status": "Uploaded",
            "icon": Icons.credit_card,
            "url": "https://quickcabpune.com/app/${vendor.documentImgUrl!}",
          });
        }

        if (vendor.licenseImgUrl?.isNotEmpty ?? false) {
          docs.add({
            "name": "License",
            "status": "Uploaded",
            "icon": Icons.badge,
            "url": "https://quickcabpune.com/app/${vendor.licenseImgUrl!}",
          });
        }

        if (vendor.shopImgUrl?.isNotEmpty ?? false) {
          docs.add({
            "name": "Shop",
            "status": "Uploaded",
            "icon": Icons.store,
            "url": "https://quickcabpune.com/app/${vendor.shopImgUrl!}",
          });
        }

        if (vendor.vehicleImgUrl?.isNotEmpty ?? false) {
          docs.add({
            "name": "Vehicle",
            "status": "Uploaded",
            "icon": Icons.directions_car,
            "url": "https://quickcabpune.com/app/${vendor.vehicleImgUrl!}",
          });
        }

        return Column(
          children: [
            // 🔹 Documents list
            Expanded(
              child: docs.isEmpty
                  ? const Center(child: Text("No documents uploaded"))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        return DocumentCard(
                          docName: doc["name"] as String,
                          docStatus: doc["status"] as String,
                          icon: doc["icon"] as IconData,
                          documentImageUrl: doc["url"] as String, // Fetched from API
                        );
                      },
                    ),
            ),

            // 🔹 Help Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsForApp.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorsForApp.colorBlue.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    "Need Help ?",
                    style: TextHelper.h5.copyWith(
                      color: ColorsForApp.blackColor,
                      fontFamily: semiBoldFont,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Contact support if you need help with document verification",
                    textAlign: TextAlign.center,
                    style: TextHelper.size18.copyWith(
                      color: ColorsForApp.blackColor,
                      fontFamily: regularFont,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsForApp.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                    icon: Icon(Icons.call, color: ColorsForApp.whiteColor),
                    label: Text(
                      "Contact Support",
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.whiteColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                    onPressed: () => Get.toNamed(Routes.HELP_PAGE),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
