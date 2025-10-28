import 'package:QuickCab/Screens/profile_module/controller/profile_controller.dart';
import 'package:QuickCab/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';
import '../../login_signup_module/controller/user_registration_controller.dart';
import '../profile_widgets/document_card.dart';
import '../profile_widgets/my_document_card_shimmer.dart';

class MyDocumentsPage extends StatelessWidget {
  const MyDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final UserRegistrationController userRegistrationController =
        Get.find<UserRegistrationController>(); // or whichever controller defines serviceDocs
    // Fetch profile details after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProfileDetails();
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Documents",
        subtitle: "My uploaded documents",
      ),
      body: Obx(() {
        // Show shimmer loader while fetching data
        if (controller.isLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => const DocumentCardShimmer(),
          );
        }

        // 🔹 Vendor info
        final vendor = controller.userDetails.value;

        if (vendor == null) {
          return const Center(child: Text("No documents found"));
        }

// 🔹 Determine vendor category
        final vendorCat = vendor.vendorCat ?? '';
        final base = Config.baseUrl;

// 🔹 Get required docs list for that category
        final requiredDocs = userRegistrationController.serviceDocs[vendorCat] ?? [];

// 🔹 Map doc title → actual field and icon
        final Map<String, Map<String, dynamic> Function()> documentFieldMap = {
          'Driving License': () => {
                'url': vendor.licenseImgUrl,
                'icon': Icons.badge,
              },
          'Aadhar Card Front': () => {
                'url': vendor.documentImgUrl,
                'icon': Icons.credit_card,
              },
          'Aadhar Card Back': () => {
                'url': vendor.documentImgUrlBack,
                'icon': Icons.credit_card,
              },
          'Vehicle Photo': () => {
                'url': vendor.vehicleImgUrl,
                'icon': Icons.directions_car,
              },
          'Shop Act License': () => {
                'url': vendor.shopImgUrl,
                'icon': Icons.store,
              },
          'Shop Photo': () => {
                'url': vendor.shopImgUrl,
                'icon': Icons.store,
              },
        };

// 🔹 Build uploaded docs list dynamically`   `
        final docs = <Map<String, dynamic>>[];

        for (final doc in requiredDocs) {
          final mapping = documentFieldMap[doc.title]?.call();
          final url = mapping?['url'];

          if (url != null && url.isNotEmpty) {
            docs.add({
              "name": doc.title,
              "status": "Uploaded",
              "icon": mapping!['icon'],
              "url": "$base$url",
            });
          }
        }

        return Column(
          children: [
            // Documents list
            Expanded(
              child: Obx(() {
                final reuploadList = controller.reUploadDocs;

                if (docs.isEmpty && reuploadList.isEmpty) {
                  return const Center(child: Text("No documents uploaded"));
                }

                // Make a copy of existing server docs
                final combinedDocs = List<Map<String, dynamic>>.from(docs);

                // ✅ Replace or append using title-based logic
                for (final reDoc in reuploadList) {
                  final matchIndex = combinedDocs.indexWhere(
                    (d) => (d["name"]?.trim() ?? "") == (reDoc.title?.trim() ?? ""),
                  );

                  if (matchIndex != -1) {
                    // ✅ Update correct doc
                    combinedDocs[matchIndex]["url"] = reDoc.filePath;
                    combinedDocs[matchIndex]["status"] = "Updated";
                  } else {
                    // ✅ Add new doc if not found
                    combinedDocs.add({
                      "name": reDoc.title ?? "Document",
                      "status": "Uploaded",
                      "icon": Icons.insert_drive_file,
                      "url": reDoc.filePath,
                    });
                  }
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: combinedDocs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = combinedDocs[index];
                    final imageUrl = doc["url"];
                    final isLocal = imageUrl != null && (imageUrl.startsWith('/') || imageUrl.startsWith('file://'));

                    return DocumentCard(
                      docName: doc["name"] as String,
                      docStatus: doc["status"] as String,
                      icon: doc["icon"] as IconData,
                      documentImageUrl: imageUrl,
                      isLocalImage: isLocal,
                      reason: '',
                      docStatusCode: vendor.status,
                      onReupload: () => controller.openUploadSheet(doc["name"], false),
                    );
                  },
                );
              }),
            ),
            if (vendor.status == 2) // assuming 2 = rejected
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () async {
                    bool result = await controller.reuploadDocumentsApi();
                    if (result) {
                      Get.offNamed(Routes.DASHBOARD_PAGE);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: ColorsForApp.primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Proceed',
                          style: TextHelper.size19.copyWith(
                            color: Colors.white,
                            fontFamily: semiBoldFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), // 🔹 Help Section
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
