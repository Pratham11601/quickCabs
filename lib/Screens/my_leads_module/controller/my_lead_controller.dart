import 'package:QuickCab/Screens/my_leads_module/model/edit_lead_model.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../api/api_manager.dart';
import '../../../utils/date_time_picker.dart';
import '../../post_lead_module/repository/post_lead_repository.dart';
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
  RxString fromLocation = ''.obs;
  RxString toLocation = ''.obs;
  RxString vendorMobile = ''.obs;
  RxInt selectedId = 0.obs;

  TextEditingController carModelController = TextEditingController();
  TextEditingController fareController = TextEditingController();

  final MyLeadRepository repository = MyLeadRepository(APIManager());
  // final PostController locCtrl = Get.find<PostController>();
  final PostLeadRepository postLeadRepository = PostLeadRepository(APIManager());

  //For debounce
  // Debounce observables (updated by onChanged)
  // final debouncePickup = ''.obs;
  // final debounceDrop = ''.obs;

  // Loading flags (optional)
  final isLoadingPickup = false.obs;
  final isLoadingDrop = false.obs;

  // Suggestions: list of maps with name/address (adapt to your model if you prefer)
  final pickupSuggestions = <Map<String, String>>[].obs;
  final dropSuggestions = <Map<String, String>>[].obs;

  // Show flags to control suggestion visibility (only when field has focus + results exist)
  final showPickupSuggestions = false.obs;
  final showDropSuggestions = false.obs;

  // Track last lengths
  int _lastPickupLength = 0;
  int _lastDropLength = 0;

  // Track last typing times
  DateTime _lastPickupInputTime = DateTime.now();
  DateTime _lastDropInputTime = DateTime.now();

  // TextEditingControllers must be persistent
  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();
  var isEditing = false.obs; // to prevent debounce firing on prefill

  // Focus nodes to detect focus and hide suggestions when out of focus
  final pickupFocus = FocusNode();
  final dropFocus = FocusNode();

  /*void setupDebouncers() {
    debounce(fromLocation, (String? val) {
      if (!isEditing.value) return; // 🚫 Ignore prefill changes
      _handlePickupDebounce(val ?? '');
    }, time: const Duration(milliseconds: 500));

    debounce(toLocation, (String? val) {
      if (!isEditing.value) return; // 🚫 Ignore prefill changes
      _handleDropDebounce(val ?? '');
    }, time: const Duration(milliseconds: 500));
  }*/

/*  void _handlePickupDebounce(String q) {
    final now = DateTime.now();
    if (q.length >= 3) {
      if (q.length > _lastPickupLength) {
        fetchLocations(q, isPickup: true);
      } else if (q.length < _lastPickupLength && now.difference(_lastPickupInputTime).inSeconds >= 3) {
        fetchLocations(q, isPickup: true);
      } else {
        pickupSuggestions.clear();
        showPickupSuggestions.value = false;
      }
    } else {
      pickupSuggestions.clear();
      showPickupSuggestions.value = false;
    }
    _lastPickupLength = q.length;
    _lastPickupInputTime = now;
  }

  void _handleDropDebounce(String q) {
    final now = DateTime.now();
    if (q.length >= 3) {
      if (q.length > _lastDropLength) {
        fetchLocations(q, isPickup: false);
      } else if (q.length < _lastDropLength && now.difference(_lastDropInputTime).inSeconds >= 3) {
        fetchLocations(q, isPickup: false);
      } else {
        dropSuggestions.clear();
        showDropSuggestions.value = false;
      }
    } else {
      dropSuggestions.clear();
      showDropSuggestions.value = false;
    }
    _lastDropLength = q.length;
    _lastDropInputTime = now;
  }*/

  @override
  void onInit() {
    super.onInit();
    fetchLeads(forceRefresh: true);
    // setupDebouncers();
    // Focus listeners: hide suggestions when field loses focus
    pickupFocus.addListener(() {
      if (!pickupFocus.hasFocus) {
        // optionally clear suggestions on blur
        // pickupSuggestions.clear();
        showPickupSuggestions.value = false;
      } else {
        // show if we already have suggestions
        showPickupSuggestions.value = pickupSuggestions.isNotEmpty;
      }
    });

    dropFocus.addListener(() {
      if (!dropFocus.hasFocus) {
        // dropSuggestions.clear();
        showDropSuggestions.value = false;
      } else {
        showDropSuggestions.value = dropSuggestions.isNotEmpty;
      }
    });
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
    // isEditing.value = false; // 🚫 disable debounce during prefill

    // fill values
    fromLocation.value = lead.locationFrom ?? '';
    toLocation.value = lead.toLocation ?? '';

    fromLocationController.text = fromLocation.value;
    toLocationController.text = toLocation.value;

    carModelController.text = lead.carModel ?? '';
    fareController.text = lead.fare ?? '';
    vendorMobile.value = lead.vendorContact ?? '';
    // Parse date string safely
    // For date

    // For time (assuming lead.time is String like "14:30")
    if (lead.time != null && lead.time!.isNotEmpty) {
      selectedTime.value = parseTimeOfDay(lead.time!);
    } else {
      selectedTime.value = null;
    }
    // enable debounce after short delay (so UI settles)
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   isEditing.value = true; // ✅ now user typing will trigger debounce
    // });
  }

  /// call this to set text and clear suggestions when user picks an item
  void selectSuggestion({required bool isPickup, required String name}) {
    if (isPickup) {
      fromLocationController.text = name;
      pickupSuggestions.clear();
      showPickupSuggestions.value = false;
      pickupFocus.unfocus();
    } else {
      toLocationController.text = name;
      dropSuggestions.clear();
      showDropSuggestions.value = false;
      dropFocus.unfocus();
    }
  }

  // Fetch locations via repository
  Future<void> fetchLocations(String query, {required bool isPickup}) async {
    try {
      // Start loader
      if (isPickup) {
        isLoadingPickup.value = true;
      } else {
        isLoadingDrop.value = true;
      }
      final response = await postLeadRepository.fetchLocationForPost(location: query);
      final results = response.results ?? [];

      final suggestions = results.map<Map<String, String>>((item) {
        return {
          "name": item.name ?? "",
          "address": item.address ?? "",
        };
      }).toList();

      if (isPickup) {
        pickupSuggestions.assignAll(suggestions);
        showPickupSuggestions.value = true;
      } else {
        dropSuggestions.assignAll(suggestions);
        showDropSuggestions.value = true;
      }
    } catch (e) {
      debugPrint("Error fetching suggestions: $e");
    } finally {
      if (isPickup) {
        isLoadingPickup.value = false;
      } else {
        isLoadingDrop.value = false;
      }
    }
  }

  Future<void> fetchLeads({bool forceRefresh = false}) async {
    // If we already have data and not forcing refresh, just return

    try {
      isLoading.value = true;
      final response = await repository.myLeadApicall();

      activeLeads.assignAll(
        response.leads.where((lead) => lead.leadStatus == "pending" && lead.isActive == true).toList(),
      );
      completedLeads.assignAll(
        response.leads.where((lead) => lead.leadStatus == "booked").toList(),
      );

      filteredActiveLeads.assignAll(activeLeads);
      filteredCompletedLeads.assignAll(completedLeads);
    } catch (e) {
      print('Error loading leads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Observables for date & time
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();

// Format date for UI
  String get formattedDate => selectedDate.value == null ? "dd/MM/yyyy" : DateFormat("dd/MM/yyyy").format(selectedDate.value!);

// Format time for UI (uses 24-hour format by default)
  String formattedTime(BuildContext ctx) => selectedTime.value == null ? "--:--" : selectedTime.value!.format(ctx);

// Convert TimeOfDay to 12-hour formatted string
  String formatTime12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  String convertStringToFormattedDate(String dateString, {String inputPattern = "yyyy-MM-dd", String outputPattern = "dd MMM yyyy"}) {
    try {
      // Parse input string to DateTime
      final inputFormat = DateFormat(inputPattern);
      DateTime dateTime = inputFormat.parse(dateString);

      // Format DateTime to desired output
      final outputFormat = DateFormat(outputPattern);
      return outputFormat.format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }

// Pick a date
  Future<void> selectFromDate(BuildContext context) async {
    final now = DateTime.now();

    // Use selectedDate if not null, else today
    final initial = selectedDate.value ?? now;

    // Ensure initialDate is not before firstDate
    final initialDate = initial.isBefore(now) ? now : initial;

    final picked = await AppDateTimePicker.pickDate(
      context,
      initialDate: initialDate,
      firstDate: now, // can't pick past dates
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

// Pick a time
  Future<void> selectFromTime(BuildContext context) async {
    final picked = await AppDateTimePicker.pickTime(
      context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
    );

    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  Rx<EditLeadModel> editModelResponse = EditLeadModel().obs;

  // Future<bool> editRideLead({bool isLoaderShow = true}) async {
  //   final params = {
  //     "date": selectedDate.value != null ? DateFormat('yyyy-MM-dd').format(selectedDate.value!) : null, // optional: omit if null
  //     "time": selectedTime.value?.format(Get.context!),
  //     "locationFrom": fromLocationController.text,
  //     "location_from_area": "",
  //     "toLocation": toLocationController.text,
  //     "to_location_area": "",
  //     "car_model": carModelController.text.trim(),
  //     "add_on": "",
  //     "fare": fareController.text.trim(),
  //     "cab_number": "",
  //     "vendor_contact": vendorMobile.value,
  //   };
  //
  //   try {
  //     isLoading.value = true;
  //     editModelResponse.value = await repository.editLeadApiCall(
  //       params: params,
  //       leadId: selectedId.value,
  //     );
  //     if (editModelResponse.value.status == true) {
  //       isLoading.value = true;
  //       return true;
  //     } else {
  //       isLoading.value = false;
  //       ShowSnackBar.error(title: 'Error', message: editModelResponse.value.message ?? 'Failed to update lead');
  //       return false;
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     ShowSnackBar.error(title: 'Error', message: 'Something went wrong. Please try again.');
  //     return false;
  //   }
  // }

  Future<bool> editRideLead({bool isLoaderShow = true}) async {
    final params = {
      "date": DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      "time": selectedTime.value?.format(Get.context!),
      "locationFrom": fromLocationController.text, // ✅ use debounce if user typed new value
      "location_from_area": "",
      "toLocation": toLocationController.text, // ✅ same for drop
      "to_location_area": "",
      "car_model": carModelController.text.trim(),
      "add_on": "",
      "fare": fareController.text.trim(),
      "cab_number": "",
      "vendor_contact": vendorMobile.value,
    };

    try {
      isLoading.value = true;
      editModelResponse.value = await repository.editLeadApiCall(
        params: params,
        leadId: selectedId.value,
      );
      if (editModelResponse.value.status == true) {
        isLoading.value = false;
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

  Future<bool> deleteRideLead({bool isLoaderShow = true}) async {
    final params = {
      "date": DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      "time": selectedTime.value?.format(Get.context!),
      "locationFrom": fromLocationController.text, // ✅ use debounce if user typed new value
      "location_from_area": "",
      "toLocation": toLocationController.text, // ✅ same for drop
      "to_location_area": "",
      "car_model": carModelController.text.trim(),
      "add_on": "",
      "fare": fareController.text.trim(),
      "cab_number": "",
      "vendor_contact": vendorMobile.value,
      "is_active": 0,
    };

    try {
      isLoading.value = true;
      editModelResponse.value = await repository.editLeadApiCall(
        params: params,
        leadId: selectedId.value,
      );
      if (editModelResponse.value.status == true) {
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        ShowSnackBar.error(title: 'Error', message: editModelResponse.value.message ?? 'Failed to delete lead');
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      ShowSnackBar.error(title: 'Error', message: 'Something went wrong. Please try again.');
      return false;
    }
  }
}
