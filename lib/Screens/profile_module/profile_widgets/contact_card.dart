import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_widgets.dart';
import '../controller/help_support_controller.dart';
import '../model/help_support_model.dart';

class ContactCard extends StatelessWidget {
  final HelpSupportData contact;

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
            // State
            Text(contact.state ?? "Unknown State", style: TextHelper.size20.copyWith(fontFamily: boldFont, color: ColorsForApp.blackColor)),
            const SizedBox(height: 8),

            // List phone numbers
            ...?contact.phoneNumbers?.map(
              (phone) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.call_outlined, size: 18, color: ColorsForApp.primaryDarkColor),
                    const SizedBox(width: 6),
                    Text(
                      phone.phoneNumber ?? "-",
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Action Buttons for each number
            Row(
              children: [
                // WhatsApp button
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
                    size: 18,
                  ),
                  label: Text(
                    "WhatsApp",
                    style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont),
                  ),
                  onPressed: () {
                    _handleContactAction(
                      context,
                      contact.phoneNumbers ?? [],
                      (selectedNumber) => openWhatsApp(selectedNumber),
                    );
                  },
                ),
                SizedBox(
                  width: 1.5.h,
                ),
                // Call button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsForApp.subtle,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.call_outlined,
                    color: ColorsForApp.whiteColor,
                    size: 18,
                  ),
                  label: Text(
                    "Call",
                    style: TextHelper.size18.copyWith(
                      color: ColorsForApp.whiteColor,
                      fontFamily: semiBoldFont,
                    ),
                  ),
                  onPressed: () {
                    _handleContactAction(
                      context,
                      contact.phoneNumbers ?? [],
                      (selectedNumber) => makeCall(selectedNumber),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog function
void _handleContactAction(
  BuildContext context,
  List<PhoneNumbers> phoneNumbers,
  Function(String) onNumberSelected,
) {
  if (phoneNumbers.isEmpty) return;

  // ✅ If only one number → directly perform action
  if (phoneNumbers.length == 1) {
    final number = phoneNumbers.first.phoneNumber;
    if (number != null && number.isNotEmpty) {
      onNumberSelected(number);
    }
    return;
  }

  // ✅ If multiple numbers → show dialog
  showDialog(
    context: context,
    builder: (ctx) {
      // Calculate dynamic height
      final itemHeight = 50.0; // approx height per item
      final maxHeight = MediaQuery.of(context).size.height * 0.5; // max 50% of screen
      final dialogHeight = (phoneNumbers.length * itemHeight).clamp(0, maxHeight).toDouble();

      return AlertDialog(
        title: Text(
          "Choose Number",
          style: TextHelper.h7.copyWith(
            color: ColorsForApp.blackColor,
            fontFamily: boldFont,
          ),
        ),
        content: SizedBox(
          height: dialogHeight,
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: phoneNumbers.length,
            itemBuilder: (context, index) {
              final phone = phoneNumbers[index];
              return InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  if (phone.phoneNumber != null && phone.phoneNumber!.isNotEmpty) {
                    onNumberSelected(phone.phoneNumber!);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        phone.phoneNumber ?? "",
                        style: TextHelper.size18.copyWith(
                          color: ColorsForApp.blackColor,
                          fontFamily: regularFont,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: ColorsForApp.subtle,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
