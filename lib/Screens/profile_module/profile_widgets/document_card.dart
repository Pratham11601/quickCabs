import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.dart';
import '../../../utils/app_colors.dart';

/// Reusable document card widget
class DocumentCard extends StatelessWidget {
  final String docName;
  final String docStatus;
  final IconData icon;
  final String? documentImageUrl; // ✅ Image of document

  const DocumentCard({
    super.key,
    required this.docName,
    required this.docStatus,
    required this.icon,
    required this.documentImageUrl,
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
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon, size: 30, color: ColorsForApp.primaryDarkColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docName,
                  style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
                ),
                const SizedBox(height: 4),
                Text(
                  docStatus,
                  style: TextHelper.size17
                      .copyWith(color: docStatus == "Verified" ? ColorsForApp.green : ColorsForApp.orange, fontFamily: semiBoldFont),
                ),
              ],
            ),
          ),
          // ✅ Document Image instead of View button
          SizedBox(
            width: 80, // fix width for image container
            height: 80,
            child: GestureDetector(
              onTap: () {
                showImagePreview(context, documentImageUrl!);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsForApp.colorBlue.withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    documentImageUrl ?? "",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80, // radius 40 * 2
                        height: 80,
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
                          radius: 40,
                          backgroundColor: Colors.transparent, // make avatar background transparent
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
          ),
        ],
      ),
    );
  }

  // ✅ Full screen image preview
  void showImagePreview(BuildContext context, String? url) {
    final displayUrl = (url != null && url.isNotEmpty) ? url : null;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16), // Prevents fullscreen overflow
        child: InteractiveViewer(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: displayUrl != null
                ? Image.network(
                    displayUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Assets.imagesQuickcabLogo,
                        fit: BoxFit.contain,
                      );
                    },
                  )
                : Image.asset(
                    Assets.imagesQuickcabLogo,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}
