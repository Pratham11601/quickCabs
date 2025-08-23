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
    // Example documents - replace with API response / GetX state
    final docs = [
      {"name": "Aadhar Card", "status": "Verified", "icon": Icons.file_copy_outlined},
      {"name": "PAN Card", "status": "Pending", "icon": Icons.file_copy_outlined},
      {"name": "Driving License", "status": "Verified", "icon": Icons.file_copy_outlined},
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Documents",
        subtitle: "My uploaded documents",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                return DocumentCard(
                  docName: doc["name"] as String,
                  docStatus: doc["status"] as String,
                  icon: doc["icon"] as IconData,
                  documentImageUrl: (doc["documentUrl"] ?? "") as String, // 👈 allow nullable
                );
              },
            ),
          ),
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
                Text("Need Help ?", style: TextHelper.h5.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                SizedBox(height: 4),
                Text("Contact support if you need help with document verification",
                    textAlign: TextAlign.center,
                    style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsForApp.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.call,
                    color: ColorsForApp.whiteColor,
                  ),
                  label:
                      Text("Contact Support", style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                  onPressed: () {
                    Get.toNamed(Routes.HELP_PAGE);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
