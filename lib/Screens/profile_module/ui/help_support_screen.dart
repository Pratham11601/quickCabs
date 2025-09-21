import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';

import '../../../widgets/common_widgets.dart';
import '../controller/help_support_controller.dart';
import '../profile_widgets/contact_card.dart';

class HelpSupportScreen extends GetView<HelpSupportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomAppBar(
        title: "Help & Support",
        subtitle: "Contact local support",
      ),
      body: Column(
        children: [
          // Info Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorsForApp.colorBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: ColorsForApp.colorBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(Icons.chat_bubble_outline,
                    size: 45, color: ColorsForApp.colorBlue),
                SizedBox(height: 8),
                Text("State-wise Support",
                    style: TextHelper.h5.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: semiBoldFont)),
                SizedBox(height: 4),
                Text("Connect with local support teams for quick assistance",
                    textAlign: TextAlign.center,
                    style: TextHelper.size18.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: regularFont)),
                SizedBox(height: 4),
                Text("Email - quickcabsservices@gmail.com",
                    textAlign: TextAlign.center,
                    style: TextHelper.size18.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: regularFont)),
              ],
            ),
          ),

          // Contacts List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.contacts.length,
                itemBuilder: (context, index) {
                  return ContactCard(contact: controller.contacts[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
