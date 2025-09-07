import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QuickCab/utils/app_colors.dart';

import '../model/docItemModel.dart';
import '../model/upload_source.dart';
import '../ui/uploadSheet.dart';

class DocVerifyController extends GetxController {
  final RxString leadBy = ''.obs; // dropdown

  final RxList<DocItem> docs = <DocItem>[
    DocItem(
      title: 'Driving License',
      subtitle: 'Valid driving license with commercial\nendorsement',
      required: true,
    ),
    DocItem(
      title: 'Vehicle Registration (RC)',
      subtitle: 'Vehicle registration certificate (optional)',
      required: false,
    ),
    DocItem(
      title: 'Vehicle Insurance',
      subtitle: 'Valid vehicle insurance policy (optional)',
      required: false,
    ),
    DocItem(
      title: 'Commercial Permit',
      subtitle: 'Commercial vehicle permit for taxi operations',
      required: true,
    ),
  ].obs;

  RxDouble progress = 0.0.obs; // 0.0 -> 1.0

  /// pick from Camera/Gallery/Files
  Future<void> uploadDoc(int index, UploadSource source) async {
    try {
      String? path;
      String? name;

      switch (source) {
        case UploadSource.camera:
          final picked = await ImagePicker().pickImage(source: ImageSource.camera);
          if (picked == null) return;
          path = picked.path;
          name = File(picked.path).uri.pathSegments.last;
          break;

        case UploadSource.gallery:
          final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (picked == null) return;
          path = picked.path;
          name = File(picked.path).uri.pathSegments.last;
          break;

        // case UploadSource.files:
        //   final result = await FilePicker.platform.pickFiles(
        //     type: FileType.custom,
        //     allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        //   );
        //   if (result == null) return;
        //   path = result.files.single.path!;
        //   name = result.files.single.name;
        //   break;
      }

      final item = docs[index];
      item.filePath = path;
      item.fileName = name;
      item.status = DocStatus.verified;
      item.date = DateTime.now();

      docs[index] = item; // Trigger UI update
      recomputeProgress();
    } catch (e) {
      debugPrint("Upload failed: $e");
    }
  }

  void replaceDoc(int index) => openUploadSheet(index);

  void deleteDoc(int index) {
    final i = docs[index];
    i.filePath = null;
    i.fileName = null;
    i.status = DocStatus.empty;
    i.date = null;
    docs[index] = i;
    recomputeProgress();
  }

  void recomputeProgress() {
    final totalRequired = docs.where((d) => d.required).length;
    final doneRequired = docs.where((d) => d.required && d.status != DocStatus.empty).length;
    progress.value = totalRequired == 0 ? 0 : doneRequired / totalRequired;
  }

  int remainingRequiredCount() {
    final totalRequired = docs.where((d) => d.required).length;
    final doneRequired = docs.where((d) => d.required && d.status != DocStatus.empty).length;
    return (totalRequired - doneRequired).clamp(0, totalRequired);
  }

  void openUploadSheet(int index) {
    Get.bottomSheet(
      UploadSheet(
        onPick: (src) async {
          Get.back();
          await uploadDoc(index, src);
        },
      ),
      backgroundColor: ColorsForApp.whiteColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
