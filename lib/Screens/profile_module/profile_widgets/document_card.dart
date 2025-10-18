import 'dart:io';

import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import '../../../utils/app_colors.dart';

/// Reusable document card widget
class DocumentCard extends StatelessWidget {
  final String docName;
  final String docStatus;
  final IconData icon;
  final String? documentImageUrl;
  final String? reason;
  final int? docStatusCode; // 0=pending, 1=verified, 2=rejected
  final VoidCallback? onReupload;
  final bool isLocalImage; // ✅ only keep this (no getter)

  const DocumentCard({
    super.key,
    required this.docName,
    required this.docStatus,
    required this.icon,
    required this.documentImageUrl,
    this.isLocalImage = false, // ✅ default false
    required this.reason,
    this.docStatusCode,
    this.onReupload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsForApp.subTitleColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: ColorsForApp.blackColor.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟣 Left-side icon
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon, size: 30, color: ColorsForApp.primaryDarkColor),
          ),
          const SizedBox(width: 16),

          // 🟣 Center: document info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docName,
                  style: TextHelper.size20.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: semiBoldFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  docStatus,
                  style: TextHelper.size17.copyWith(
                    color: docStatus == "Verified" ? ColorsForApp.green : ColorsForApp.orange,
                    fontFamily: semiBoldFont,
                  ),
                ),
              ],
            ),
          ),

          // 🟣 Right-side: image + reupload button
          SizedBox(
            width: 90,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Image preview thumbnail
                GestureDetector(
                  onTap: () {
                    if (documentImageUrl != null && documentImageUrl!.isNotEmpty) {
                      showImagePreview(context, documentImageUrl!);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorsForApp.colorBlue.withValues(alpha: 0.2),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isLocalImage
                          ? Image.file(
                              File(documentImageUrl!),
                              fit: BoxFit.cover,
                              height: 70,
                              width: 70,
                            )
                          : Image.network(
                              documentImageUrl ?? "",
                              fit: BoxFit.cover,
                              height: 70,
                              width: 70,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorsForApp.blackColor,
                                        ColorsForApp.subTitleColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      Assets.iconsLogo,
                                      height: 40,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ✅ Show re-upload button only for rejected docs
                if (docStatusCode == 2)
                  ElevatedButton(
                    onPressed: onReupload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsForApp.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Re-upload",
                      style: TextHelper.size16.copyWith(
                        color: Colors.white,
                        fontFamily: semiBoldFont,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Full-screen image preview dialog
  void showImagePreview(BuildContext context, String imageUrl) {
    final isLocal = imageUrl.startsWith("/") || imageUrl.startsWith("file://");

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: isLocal
                ? Image.file(File(imageUrl), fit: BoxFit.contain)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(Assets.imagesQuickcabLogo);
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
