import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../controller/help_support_controller.dart';
import '../model/support_contact_model.dart';

class ContactCard extends StatelessWidget {
  final SupportContact contact;

  ContactCard({super.key, required this.contact});

  final HelpSupportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City + State
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(contact.city, style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                const Icon(Icons.location_on_outlined, size: 30, color: ColorsForApp.primaryDarkColor),
              ],
            ),
            Text(contact.state, style: TextHelper.size18.copyWith(color: ColorsForApp.subTitleColor, fontFamily: semiBoldFont)),

            const SizedBox(height: 2),

            // Contact Info
            Text("WhatsApp: ${contact.whatsapp}",
                style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
            Text("Phone: ${contact.phone}", style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Whatsapp
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsForApp.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.whatsapp,
                    color: ColorsForApp.whiteColor,
                  ),
                  label: Text("WhatsApp", style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                  onPressed: () => controller.openWhatsApp(contact.whatsapp),
                ),
                // Call
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsForApp.subTitleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.call_outlined,
                    color: ColorsForApp.whiteColor,
                  ),
                  label: Text("Call", style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                  onPressed: () => controller.makeCall(contact.phone),
                ),
                // Email
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsForApp.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.email_outlined,
                    color: ColorsForApp.whiteColor,
                  ),
                  label: Text("Email", style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                  onPressed: () => controller.sendEmail(contact.email),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
