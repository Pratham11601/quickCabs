import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:own_idea/utils/app_colors.dart';

import '../model/docItemModel.dart';
import '../model/upload_source.dart';
import '../ui/uploadSheet.dart';

class DocVerifyController extends GetxController {
// Service types
  final RxList<String> serviceTypes = <String>[
    'Cab',
    'Towing',
    'Repairing',
    'Puncture',
    'Drivers',
    'Fuel',
    'Restaurant',
    'Hospital',
    'Car Sell'
  ].obs;

// Selected service - only one at a time
  final RxString selectedService = 'Cab'.obs;

// Toggle service selection
  void toggleServiceType(String type) {
    print("Toggling service type: $type");
    selectedService.value = type; // sirf ek service rakhega
    docs.assignAll(serviceDocs[type] ?? []);
    recomputeProgress();

    print("Selected service now: ${selectedService.value}");
  }

  final RxString leadBy = ''.obs; // dropdown

  // Dynamic document requirements for each service type
  final Map<String, List<DocItem>> serviceDocs = {
    'Cab': [
      DocItem(
        title: 'Driving License',
        subtitle: 'Valid commercial driving license',
        required: true,
      ),
      DocItem(
        title: 'Vehicle RC',
        subtitle: 'Vehicle registration certificate',
        required: true,
      ),
      DocItem(
        title: 'Vehicle Photo',
        subtitle: 'Clear photo of your vehicle',
        required: true,
      ),
    ],
    'Drivers': [
      DocItem(
        title: 'Driving License',
        subtitle: 'Valid driving license',
        required: true,
      ),
    ],
    'Puncture': [
      DocItem(
        title: 'Shop Act License',
        subtitle: 'Valid shop act license',
        required: true,
      ),
    ],
    'Fuel': [
      DocItem(
        title: 'Shop Act License',
        subtitle: 'Valid shop act license',
        required: true,
      ),
    ],
    // baaki sab types me default ek hi document
    'Towing': [
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
    'Repairing': [
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
    'Restaurant': [
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
    'Hospital': [
      DocItem(
        title: 'Shop Photo',
        subtitle: 'Clear photo of your shop',
        required: true,
      ),
    ],
  };

  final RxList<DocItem> docs = <DocItem>[].obs;

  // void loadDocsForService(String service) {
  //   selectedService.value = service;
  //   docs.assignAll(serviceDocs[service] ?? []);
  //   recomputeProgress();
  // }

  RxDouble progress = 0.0.obs; // 0.0 -> 1.0

  /// pick from Camera/Gallery/Files
  Future<void> uploadDoc(int index, UploadSource source) async {
    try {
      String? path;
      String? name;

      switch (source) {
        case UploadSource.camera:
          final picked =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (picked == null) return;
          path = picked.path;
          name = File(picked.path).uri.pathSegments.last;
          break;

        case UploadSource.gallery:
          final picked =
              await ImagePicker().pickImage(source: ImageSource.gallery);
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
    final doneRequired =
        docs.where((d) => d.required && d.status != DocStatus.empty).length;
    progress.value = totalRequired == 0 ? 0 : doneRequired / totalRequired;
  }

  int remainingRequiredCount() {
    final totalRequired = docs.where((d) => d.required).length;
    final doneRequired =
        docs.where((d) => d.required && d.status != DocStatus.empty).length;
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
