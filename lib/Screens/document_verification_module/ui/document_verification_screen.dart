import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/document_verification_module/controller/document_verification_controller.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:own_idea/utils/text_styles.dart';

import '../model/docItemModel.dart';

class DocumentVerificationPage extends StatelessWidget {
  DocumentVerificationPage({super.key});

  final DocVerifyController docVerifyController = Get.put(DocVerifyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.bg,
      body: Column(
        children: [
          Header(controller: docVerifyController),
          Expanded(
            child: Obx(() => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    LeadByCard(controller: docVerifyController),
                    const SizedBox(height: 16),
                    ...List.generate(docVerifyController.docs.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: i == docVerifyController.docs.length - 1 ? 0 : 16),
                        child: DocCard(index: i, controller: docVerifyController),
                      );
                    }),
                    const SizedBox(height: 16),
                    HelpBox(),
                    const SizedBox(height: 16),
                    FooterBanner(controller: docVerifyController),
                    const SizedBox(height: 18),
                    Text(
                      'All required documents must be uploaded to continue',
                      textAlign: TextAlign.center,
                      style: TextHelper.size18.copyWith(color: ColorsForApp.subtitle),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

/// ---------- HEADER ----------
class Header extends StatelessWidget {
  const Header({required this.controller});
  final DocVerifyController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorsForApp.gradientTop, ColorsForApp.gradientBottom],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: back + title + logo + progress pill
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: Get.back,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Document Verification',
                          style: TextHelper.h6.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final pct = (controller.progress.value * 100).round();
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorsForApp.pill,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.white.withValues(alpha: .4)),
                    ),
                    child: Text('$pct% \nComplete', textAlign: TextAlign.center, style: TextHelper.size16.copyWith(color: Colors.white)),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),

            // Subtitle with icon
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.description_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Document Upload',
                        style: TextHelper.size20.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Complete required documents to\ncontinue',
                        style: TextHelper.size17.copyWith(color: Colors.white, fontFamily: semiBoldFont),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 14),

            // progress bar + labels
            Obx(() => Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: controller.progress.value.clamp(0, 1),
                        backgroundColor: ColorsForApp.whiteColor.withValues(alpha: .25),
                        valueColor: AlwaysStoppedAnimation<Color>(ColorsForApp.whiteColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        dotLabel('Driving', left: true),
                        const Spacer(),
                        dotLabel('Commercial', left: false),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget dotLabel(String text, {required bool left}) {
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: .25),
            border: Border.all(color: Colors.white.withValues(alpha: .7), width: 2),
          ),
        ),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

/// ---------- LEAD BY CARD ----------
class LeadByCard extends StatelessWidget {
  const LeadByCard({required this.controller});
  final DocVerifyController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsForApp.strokeSoft),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: const Color(0xFFB8ECFF), borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.center,
            child: const Icon(Icons.person_outline_rounded, color: Colors.blue, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lead By',
                  style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
                ),
                const SizedBox(height: 10),
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.leadBy.value.isEmpty ? null : controller.leadBy.value,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: ColorsForApp.orange, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: ColorsForApp.orange, width: 2),
                        ),
                      ),
                      hint: Text(
                        'Select who referred you',
                        style: TextHelper.size17.copyWith(color: ColorsForApp.subTitleColor),
                      ),
                      items: [
                        DropdownMenuItem(
                            value: 'Aman Khandekar',
                            child: Text(
                              'Aman Khandekar',
                              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                            )),
                        DropdownMenuItem(
                            value: 'Pratham Patne',
                            child: Text(
                              'Pratham Patne',
                              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                            )),
                        DropdownMenuItem(
                            value: 'Marketing Team',
                            child: Text(
                              'Marketing Team',
                              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                            )),
                        DropdownMenuItem(
                            value: 'No Referral',
                            child: Text(
                              'No Referral',
                              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                            )),
                      ],
                      onChanged: (v) => controller.leadBy.value = v ?? '',
                    )),
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
  const DocCard({required this.index, required this.controller});
  final int index;
  final DocVerifyController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final d = controller.docs[index];
      final chip = d.status == DocStatus.verified
          ? Chip(text: 'Verified', color: ColorsForApp.orange)
          : Chip(text: d.required ? 'Required' : 'Optional', color: ColorsForApp.orange);

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: ColorsForApp.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorsForApp.stroke),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description_outlined, size: 26, color: Colors.black54),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(d.title,
                                style: TextHelper.size20.copyWith(height: 1.1, color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                          ),
                          chip,
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(d.subtitle, style: TextHelper.size18.copyWith(height: 1.35, color: ColorsForApp.blackColor)),
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
                    side: const BorderSide(color: ColorsForApp.orange, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => controller.openUploadSheet(index),
                  icon: const Icon(Icons.upload_rounded, color: ColorsForApp.orange),
                  label: Text('Upload Document', style: TextHelper.size18.copyWith(color: ColorsForApp.orange, fontFamily: semiBoldFont)),
                ),
              )
            else ...[
              // ---- SUCCESS ROW
              Row(
                children: [
                  Icon(Icons.check_circle, color: ColorsForApp.colorVerifyGreen, size: 24),
                  SizedBox(width: 10),
                  Text('Document uploaded successfully',
                      style: TextHelper.size18.copyWith(color: ColorsForApp.colorVerifyGreen, fontFamily: semiBoldFont)),
                ],
              ),
              const SizedBox(height: 10),
              // file name + date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      d.fileName ?? '',
                      style: const TextStyle(fontSize: 16, color: ColorsForApp.title),
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
                      Get.snackbar('Preview', d.fileName ?? '', snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
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

/// ---------- HELP BOX ----------
class HelpBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: ColorsForApp.helpBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsForApp.helpBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Need Help?', style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
          SizedBox(height: 10),
          Bullet('Documents should be clear and readable'),
          Bullet('Supported formats: JPG, PNG, PDF'),
          Bullet('Maximum file size: 5MB per document'),
          Bullet('Verification typically takes 24–48 hours'),
        ],
      ),
    );
  }
}

class Bullet extends StatelessWidget {
  const Bullet(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Text('•  ', style: TextStyle(fontSize: 18, height: 1.2)),
          Expanded(child: Text(text, style: TextHelper.size18.copyWith(height: 1.2, color: ColorsForApp.title))),
        ],
      ),
    );
  }
}

/// ---------- FOOTER BANNER ----------
class FooterBanner extends StatelessWidget {
  const FooterBanner({required this.controller});
  final DocVerifyController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final remaining = controller.remainingRequiredCount();
      final text = remaining == 0 ? 'All required documents uploaded' : '$remaining more documents needed';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: ColorsForApp.cta,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(text, style: TextHelper.size19.copyWith(color: Colors.white, fontFamily: semiBoldFont)),
          ],
        ),
      );
    });
  }
}

/// ---------- SMALL WIDGETS ----------
class Chip extends StatelessWidget {
  const Chip({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: .6)),
      ),
      child: Text(text, style: TextHelper.size16.copyWith(color: color, fontFamily: semiBoldFont)),
    );
  }
}

class ActionLink extends StatelessWidget {
  const ActionLink({required this.icon, required this.color, required this.label, required this.onTap});
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextHelper.size19.copyWith(color: color, fontFamily: semiBoldFont)),
          ],
        ),
      ),
    );
  }
}
