import 'package:QuickCab/Screens/my_leads_module/model/edit_lead_model.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../api/api_manager.dart';
import '../model/mylead_model.dart';
import '../repository/mylead_repository.dart';

class MyLeadsController extends GetxController {
  var isLoading = false.obs;
  var activeLeads = <Lead>[].obs;
  var completedLeads = <Lead>[].obs;
  var filteredActiveLeads = <Lead>[].obs;
  var filteredCompletedLeads = <Lead>[].obs;

  // Observable fields
  RxBool isTripActive = true.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  RxString fromLocation = ''.obs;
  RxString toLocation = ''.obs;
  RxInt selectedId = 0.obs;

  TextEditingController carModelController = TextEditingController();
  TextEditingController fareController = TextEditingController();

  final MyLeadRepository repository = MyLeadRepository(APIManager());

  @override
  void onInit() {
    super.onInit();
    fetchLeads(forceRefresh: true);
  }

  TimeOfDay parseTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return TimeOfDay.now();
    }
    final parts = timeString.split(":");
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : "0") ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Method to set lead data before editing
  void setLeadData(Lead lead) {
    isTripActive.value = int.tryParse('${lead.isActive}') == 1;

    selectedDate.value = lead.date ?? DateTime.now();

    // ✅ convert string/object to TimeOfDay
    if (lead.time is String) {
      selectedTime.value = parseTimeOfDay(lead.time as String);
    } else if (lead.time is TimeOfDay) {
      selectedTime.value = lead.time as TimeOfDay;
    } else {
      selectedTime.value = TimeOfDay.now();
    }

    fromLocation.value = lead.locationFrom ?? '';
    toLocation.value = lead.toLocation ?? '';

    carModelController.text = lead.carModel ?? '';
    fareController.text = lead.fare ?? '';
  }

  Future<void> fetchLeads({bool forceRefresh = false}) async {
    // If we already have data and not forcing refresh, just return
    if (!forceRefresh && activeLeads.isNotEmpty && completedLeads.isNotEmpty) {
      return;
    }

    try {
      isLoading(true);
      final response = await repository.myLeadApicall();

      activeLeads.assignAll(
        response.leads.where((lead) => lead.isActive == true).toList(),
      );
      completedLeads.assignAll(
        response.leads.where((lead) => lead.isActive == false).toList(),
      );

      filteredActiveLeads.assignAll(activeLeads);
      filteredCompletedLeads.assignAll(completedLeads);
    } catch (e) {
      print('Error loading leads: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterLeads(String query) {
    if (query.isEmpty) {
      filteredActiveLeads.assignAll(activeLeads);
      filteredCompletedLeads.assignAll(completedLeads);
    } else {
      filteredActiveLeads.assignAll(activeLeads
          .where((lead) =>
              (lead.locationFrom ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (lead.toLocation ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (lead.fare ?? '').contains(query))
          .toList());

      filteredCompletedLeads.assignAll(completedLeads
          .where((lead) =>
              (lead.locationFrom ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (lead.toLocation ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (lead.fare ?? '').contains(query))
          .toList());
    }
  }

  Rx<EditLeadModel> editModelResponse = EditLeadModel().obs;

  Future<bool> editRideLead({bool isLoaderShow = true}) async {
    final params = {
      "date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
      "time": selectedTime.value.format(Get.context!),
      "location_from": fromLocation.value,
      "location_from_area": "",
      "to_location": toLocation.value,
      "to_location_area": "",
      "car_model": carModelController.text.trim(),
      "add_on": "",
      "fare": fareController.text.trim(),
      "cab_number": "",
      "vendor_contact": "",
    };
    try {
      isLoading.value = true;
      editModelResponse.value = await repository.editLeadApiCall(
        params: params,
        leadId: selectedId.value,
      );
      if (editModelResponse.value.status == true) {
        isLoading.value = true;
        return true;
      } else {
        isLoading.value = false;
        ShowSnackBar.error(title: 'Error', message: editModelResponse.value.message ?? 'Failed to update lead');
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.error(title: 'Error', message: 'Something went wrong. Please try again.');
      return false;
    }
  }
}
