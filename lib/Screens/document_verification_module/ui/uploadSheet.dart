import 'package:flutter/material.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:own_idea/utils/text_styles.dart';

import '../model/upload_source.dart';

class UploadSheet extends StatelessWidget {
  final void Function(UploadSource) onPick;
  const UploadSheet({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: Text(
            "Take Photo",
            style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
          ),
          onTap: () => onPick(UploadSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: Text(
            "Choose from Gallery",
            style: TextHelper.size19.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
          ),
          onTap: () => onPick(UploadSource.gallery),
        ),
        // ListTile(
        //   leading: const Icon(Icons.insert_drive_file),
        //   title: const Text("Pick from Files"),
        //   onTap: () => onPick(UploadSource.files),
        // ),
      ],
    );
  }
}
