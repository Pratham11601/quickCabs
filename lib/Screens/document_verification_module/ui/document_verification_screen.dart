import 'package:flutter/material.dart' hide Chip;
import 'package:get/get.dart';
import 'package:QuickCab/Screens/document_verification_module/controller/document_verification_controller.dart';
import 'package:QuickCab/Screens/login_signup_module/controller/signup_controller.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';

import '../../../routes/routes.dart';
import '../../../widgets/common_widgets.dart';
import '../model/docItemModel.dart';

class DocumentVerificationPage extends StatelessWidget {
  DocumentVerificationPage({super.key});

  final DocVerifyController docVerifyController =
      Get.put(DocVerifyController());
  final SignupController signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.bg,
      body: Column(
        children: [
          DocHeader(controller: docVerifyController),
          Expanded(
            child: Obx(() => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    LeadByCard(signupController: signupController),
                    const SizedBox(height: 16),
                    ...List.generate(docVerifyController.docs.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: i == docVerifyController.docs.length - 1
                                ? 0
                                : 16),
                        child:
                            DocCard(index: i, controller: docVerifyController),
                      );
                    }),
                    const SizedBox(height: 16),
                    DocHelpBox(),
                    const SizedBox(height: 16),
                    FooterProceedButton(controller: docVerifyController),
                    const SizedBox(height: 18),
                    Text(
                      'All required documents must be uploaded to continue',
                      textAlign: TextAlign.center,
                      style: TextHelper.size18
                          .copyWith(color: ColorsForApp.subtitle),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

/// ---------- LEAD BY CARD ----------
class LeadByCard extends StatelessWidget {
  final SignupController signupController;

  const LeadByCard({super.key, required this.signupController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: ColorsForApp.subTitleColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ColorsForApp.subtle.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person_outline_rounded,
                color: Colors.black54, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lead By',
                  style: TextHelper.size20.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: semiBoldFont,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: signupController.leadBy.value.isEmpty
                        ? null
                        : signupController.leadBy.value,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorsForApp.blackColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: ColorsForApp.orange, width: 1),
                      ),
                    ),
                    style: TextHelper.size19.copyWith(
                      color: ColorsForApp.blackColor,
                      fontFamily: semiBoldFont,
                    ),
                    hint: Text(
                      'Select who referred you',
                      style: TextHelper.size19.copyWith(
                        color: ColorsForApp.subTitleColor,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                    items: signupController.leadByList
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item.name, // depends on your API model field
                            child: Text(
                              item.name ?? '',
                              style: TextHelper.size18
                                  .copyWith(color: ColorsForApp.blackColor),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => signupController.leadBy.value = v ?? '',
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// ---------- DOCUMENT CARD ----------
class DocCard extends StatelessWidget {
  const DocCard({super.key, required this.index, required this.controller});
  final int index;
  final DocVerifyController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final d = controller.docs[index];
      final chip = d.status == DocStatus.verified
          ? Chip(text: 'Verified', color: ColorsForApp.orange)
          : Chip(
              text: d.required ? 'Required' : 'Optional',
              color: ColorsForApp.orange);

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: ColorsForApp.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorsForApp.stroke),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description_outlined,
                    size: 26, color: Colors.black54),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(d.title,
                                style: TextHelper.size20.copyWith(
                                    height: 1.1,
                                    color: ColorsForApp.blackColor,
                                    fontFamily: semiBoldFont)),
                          ),
                          chip,
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(d.subtitle,
                          style: TextHelper.size18.copyWith(
                              height: 1.35, color: ColorsForApp.blackColor)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (!d.hasFile) // ---- EMPTY STATE (Upload button)
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side:
                        const BorderSide(color: ColorsForApp.orange, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => controller.openUploadSheet(index),
                  icon: const Icon(Icons.upload_rounded,
                      color: ColorsForApp.orange),
                  label: Text('Upload Document',
                      style: TextHelper.size18.copyWith(
                          color: ColorsForApp.orange,
                          fontFamily: semiBoldFont)),
                ),
              )
            else ...[
              // ---- SUCCESS ROW
              Row(
                children: [
                  Icon(Icons.check_circle,
                      color: ColorsForApp.colorVerifyGreen, size: 24),
                  SizedBox(width: 10),
                  Text('Document uploaded successfully',
                      style: TextHelper.size18.copyWith(
                          color: ColorsForApp.colorVerifyGreen,
                          fontFamily: semiBoldFont)),
                ],
              ),
              const SizedBox(height: 10),
              // file name + date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      d.fileName ?? '',
                      style: const TextStyle(
                          fontSize: 16, color: ColorsForApp.title),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _fmtDate(d.date),
                    style: TextHelper.size18.copyWith(
                      color: ColorsForApp.subtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // actions: Preview Replace Delete
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionLink(
                    icon: Icons.remove_red_eye_outlined,
                    color: Colors.blue,
                    label: 'Preview',
                    onTap: () {
                      if (d.filePath == null) return;
                      Get.snackbar('Preview', d.fileName ?? '',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(12));
                    },
                  ),
                  ActionLink(
                    icon: Icons.autorenew_rounded,
                    color: ColorsForApp.yellow,
                    label: 'Replace',
                    onTap: () => controller.replaceDoc(index),
                  ),
                  ActionLink(
                    icon: Icons.delete_outline_rounded,
                    color: ColorsForApp.red,
                    label: 'Delete',
                    onTap: () => controller.deleteDoc(index),
                  ),
                ],
              ),
            ]
          ],
        ),
      );
    });
  }

  static String _fmtDate(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString().padLeft(4, '0');
    return '$dd/$mm/$yy';
  }
}

/// ---------- FOOTER Button for proceed ----------
class FooterProceedButton extends StatelessWidget {
  const FooterProceedButton({super.key, required this.controller});
  final DocVerifyController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final remaining = controller.remainingRequiredCount();
      final allUploaded = remaining == 0;

      final text = allUploaded
          ? 'Proceed to verify'
          : '$remaining more documents needed';

      return GestureDetector(
        onTap: allUploaded
            ? () {
                // Show dialog when all docs uploaded
                showAppDialog(
                  title: 'Document uploaded successfully',
                  message: 'Your verification is in process.',
                  icon: Icons.check_circle_rounded,
                  buttonText: 'OK',
                  onConfirm: () {
                    Get.offAllNamed(Routes.DASHBOARD_PAGE);
                  },
                );
              }
            : null, // disabled when docs missing
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: allUploaded
                ? ColorsForApp.primaryColor
                : ColorsForApp.cta, // toggle background
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextHelper.size19.copyWith(
                  color: Colors.white,
                  fontFamily: semiBoldFont,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
