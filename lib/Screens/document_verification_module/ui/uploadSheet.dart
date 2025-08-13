import 'package:flutter/material.dart';

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
          title: const Text("Take Photo"),
          onTap: () => onPick(UploadSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("Choose from Gallery"),
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
