import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../api/api_manager.dart';
import '../../../notificaton/send_notification.dart';
import '../../../routes/routes.dart';
import '../../../utils/date_time_picker.dart';
import '../repository/post_lead_repository.dart';

class PostController extends GetxController {
  // ── Stepper ──────────────────────────────────────────────────────────────────
  final RxInt step = 1.obs; // 1..3
  final isLoading = false.obs; // True when API call is in progress

  // ── Route Details ────────────────────────────────────────────────────────────
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController pickupAreaController = TextEditingController();
  final TextEditingController dropAreaController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();

  // ── Trip Type ────────────────────────────────────────────────────────────────
  final RxInt tripType = 0.obs;

  // ── Vehicle & Seat Config ────────────────────────────────────────────────────
  /// Vehicle selection
  final RxnInt selectedVehicleIndex = RxnInt();
  final RxnInt selectedSubTypeIndex = RxnInt();
  final RxnInt selectedSeatConfig = RxnInt();

  /// Show main vehicle grid or subtype grid
  final RxBool showMainVehicles = true.obs;

  /// Vehicles list
  // If a vehicle needs seat configuration, mark it with "seatConfig": true
  final List<Map<String, dynamic>> vehicles = <Map<String, dynamic>>[
    {"name": "Hatchback", "seats": "", "color": Colors.orange},
    {"name": "Sedan", "seats": "", "color": Colors.blue},
    {"name": "SUV", "seats": "", "color": Colors.green},
    {"name": "Tempo Traveler", "seats": "", "color": Colors.blue},
    {"name": "Force Urbania", "seats": "", "color": Colors.red},
    {"name": "Mini Bus", "seats": "", "color": Colors.blue},
    {"name": "Bus", "seats": "", "color": Colors.green, "seatConfig": true},
    {"name": "Only Parcel", "seats": "", "color": Colors.red},
  ];

  /// Vehicle subtypes with colors
  final Map<String, List<Map<String, dynamic>>> vehicleSubTypes = {
    "Sedan": [
      {"name": "Desire", "color": Colors.blue},
      {"name": "Etios", "color": Colors.blue},
      {"name": "Xcent Aura", "color": Colors.blue}
    ],
    "SUV": [
      {"name": "Innova", "color": Colors.green},
      {"name": "Innova Crysta", "color": Colors.green},
      {"name": "Ertiga", "color": Colors.green},
      {"name": "Tavera", "color": Colors.green}
    ],
  };

  /// Select a main vehicle
  void selectVehicle(int index) {
    selectedVehicleIndex.value = index;
    selectedSubTypeIndex.value = null;

    final vehicleName = vehicles[index]["name"] as String;
    if (vehicleSubTypes.containsKey(vehicleName)) {
      showMainVehicles.value = false; // show subtypes
    } else {
      showMainVehicles.value = true; // keep showing main grid
    }
  }

  /// Select a subtype
  void selectSubType(int index) {
    selectedSubTypeIndex.value = index;
  }

  /// Reset selection (e.g., go back to main vehicle grid)
  void resetSelection() {
    selectedVehicleIndex.value = null;
    selectedSubTypeIndex.value = null;
    showMainVehicles.value = true;
  }

  /// Get selected vehicle string
  String getSelectedCarModel() {
    if (selectedVehicleIndex.value == null) return "";

    final vehicle = vehicles[selectedVehicleIndex.value!];
    final vehicleName = vehicle["name"] as String;
    final seat = selectedSeatConfig.value != null ? " ${selectedSeatConfig.value} Seater" : "";

    // Check if subtype selected
    if (selectedSubTypeIndex.value != null && vehicleSubTypes.containsKey(vehicleName)) {
      final subType = vehicleSubTypes[vehicleName]![selectedSubTypeIndex.value!]["name"] as String;
      return "$vehicleName - $subType$seat";
    }

    return "$vehicleName$seat";
  }

  void selectSeatConfig(int seats) => selectedSeatConfig.value = seats;

  // ── Date & Time ──────────────────────────────────────────────────────────────
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();

  String get formattedDate => selectedDate.value == null ? "dd/mm/yyyy" : DateFormat("dd/MM/yyyy").format(selectedDate.value!);

  String formattedTime(BuildContext ctx) => selectedTime.value == null ? "--:--" : selectedTime.value!.format(ctx);

  String formatTime12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  double get progress => currentStep.value / 3.0;
  String get progressPercentLabel => "${(progress * 100).round()}% Complete";

  // ── Actions ──────────────────────────────────────────────────────────────────
  void selectTripType(String type) {
    if (type == "Return Trip") {
      tripType.value = 1;
    } else if (type == "One Way") {
      tripType.value = 0;
    } else if (type == "Rented") {
      tripType.value = 2;
    } else {
      tripType.value = 3;
    }
  }

  void validateForm() {
    isFormValid.value = pickupController.text.isNotEmpty && dropController.text.isNotEmpty;
  }

  Future<void> selectFromDate(BuildContext context) async {
    final picked = await AppDateTimePicker.pickDate(
      context,
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> selectFromTime(BuildContext context) async {
    final picked = await AppDateTimePicker.pickTime(
      context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  var currentStep = 0.obs;
  var isFormValid = false.obs; // this will control the Next button enabled/disabled

  bool validateTripInformation() {
    // Validate Date
    if (selectedDate.value == null) {
      ShowSnackBar.info(title: 'Date', message: "Please select a date");
      return false;
    }

    // Validate Time
    if (selectedTime.value == null) {
      ShowSnackBar.info(title: 'Time', message: "Please select a time");
      return false;
    }

    // Validate Seat Selection (if seatConfig true)
    final int? idx = selectedVehicleIndex.value;
    if (idx != null && vehicles[idx]["seatConfig"] == true) {
      if (selectedSeatConfig.value == null) {
        ShowSnackBar.info(title: 'Select Seat', message: "Please select a Seat Configuration");

        return false;
      }
    }

    return true;
  }

  void nextStep() {
    if (isFormValid.value) {
      if (currentStep.value < 2) {
        currentStep.value++;
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void cancel() {
    // you can clear form or navigate back
    Get.offAllNamed(Routes.DASHBOARD_PAGE);
  }

  @override
  void onInit() {
    super.onInit();

    // Listen to text changes
    pickupController.addListener(validateForm);
    dropController.addListener(validateForm);

    // Listen to text changes with debounce
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

  @override
  void onClose() {
    // pickupController.dispose();
    // dropController.dispose();
    super.onClose();
  }

  //------------------api logic----------------

  // Focus nodes to detect focus and hide suggestions when out of focus
  final pickupFocus = FocusNode();
  final dropFocus = FocusNode();

  // Debounce observables (updated by onChanged)
/*  final debouncePickup = ''.obs;
  final debounceDrop = ''.obs;*/

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
  /* int _lastPickupLength = 0;
  int _lastDropLength = 0;

  // Track last typing times
  DateTime _lastPickupInputTime = DateTime.now();
  DateTime _lastDropInputTime = DateTime.now();*/

  /*void setupDebouncers() {
    // Pickup debounce
    debounce(debouncePickup, (String? val) {
      final q = val?.trim() ?? '';
      final now = DateTime.now();

      if (q.length >= 3) {
        if (q.length > _lastPickupLength) {
          // ✅ Forward typing → call API
          fetchLocations(q, isPickup: true);
        } else if (q.length < _lastPickupLength) {
          // ⏳ Backspace → only call if 3s passed since last input
          if (now.difference(_lastPickupInputTime).inSeconds >= 3) {
            fetchLocations(q, isPickup: true);
          } else {
            // Too quick backspace → just clear suggestions
            pickupSuggestions.clear();
            showPickupSuggestions.value = false;
          }
        }
      } else {
        pickupSuggestions.clear();
        showPickupSuggestions.value = false;
      }

      _lastPickupLength = q.length;
      _lastPickupInputTime = now;
    }, time: const Duration(milliseconds: 500));

    // Drop debounce
    debounce(debounceDrop, (String? val) {
      final q = val?.trim() ?? '';
      final now = DateTime.now();

      if (q.length >= 3) {
        if (q.length > _lastDropLength) {
          // ✅ Forward typing → call API
          fetchLocations(q, isPickup: false);
        } else if (q.length < _lastDropLength) {
          // ⏳ Backspace → only call if 3s passed
          if (now.difference(_lastDropInputTime).inSeconds >= 3) {
            fetchLocations(q, isPickup: false);
          } else {
            dropSuggestions.clear();
            showDropSuggestions.value = false;
          }
        }
      } else {
        dropSuggestions.clear();
        showDropSuggestions.value = false;
      }

      _lastDropLength = q.length;
      _lastDropInputTime = now;
    }, time: const Duration(milliseconds: 500));
  }*/

  /// Called when pickup text changes
  void onPickupChanged(String val) {
    if (val.trim().length >= 3) {
      fetchLocations(val.trim(), isPickup: true);
    } else {
      pickupSuggestions.clear();
      showPickupSuggestions.value = false;
    }
  }

  /// Called when drop text changes
  void onDropChanged(String val) {
    if (val.trim().length >= 3) {
      fetchLocations(val.trim(), isPickup: false);
    } else {
      dropSuggestions.clear();
      showDropSuggestions.value = false;
    }
  }

  /// API call
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

  /// call this to set text and clear suggestions when user picks an item
  void selectSuggestion({required bool isPickup, required String name, required String address}) {
    if (isPickup) {
      pickupController.text = name;
      pickupAreaController.text = address;
      pickupSuggestions.clear();
      showPickupSuggestions.value = false;
      pickupFocus.unfocus();
    } else {
      dropController.text = name;
      dropAreaController.text = address;
      dropSuggestions.clear();
      showDropSuggestions.value = false;
      dropFocus.unfocus();
    }
  }

  final PostLeadRepository postLeadRepository = PostLeadRepository(APIManager());

  Future<void> submitRideLead({bool isLoaderShow = true}) async {
    final params = {
      "date": selectedDate.value == null ? "" : DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      "time": selectedTime.value == null ? "" : formatTime12Hour(selectedTime.value!),
      "location_from": pickupController.text.trim(),
      "location_from_area": pickupAreaController.text,
      "to_location": dropController.text.trim(),
      "to_location_area": dropAreaController.text,
      "car_model": getSelectedCarModel(),
      "add_on": "",
      "fare": int.tryParse(fareController.text.trim()) ?? 0,
      "cab_number": "",
      "vendor_contact": "",
      "trip_type": tripType.value,
    };

    try {
      isLoading.value = true;
      final response = await postLeadRepository.postLeadApiCall(isLoaderShow: isLoaderShow, params: params);
      if (response.status == true) {
        await SendNotificationService.sendNotificationUsingApi(
            pickupAreaController.text, dropAreaController.text, "${int.tryParse(fareController.text) ?? 00}");
        showAppDialog(
          title: 'Lead Shared Successfully',
          message: 'Your ride lead has been shared with the driver network. Other drivers can now see and contact you for this trip.',
          icon: Icons.check_circle_rounded,
          buttonText: 'OK',
          onConfirm: () {
            Get.offAllNamed(Routes.DASHBOARD_PAGE);
          },
        );
      } else {
        isLoading.value = false;
        ShowSnackBar.error(title: 'Error', message: response.message ?? 'Failed to share lead');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong. Please try again.');
      debugPrint('Error in submitRideLead: $e');
    }
  }

  void showAppDialog({
    required String title,
    required String message,
    required IconData icon,
    required String buttonText,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // rounded corners
        ),
        backgroundColor: Colors.white, // full white background
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.12),
                ),
                padding: EdgeInsets.all(20),
                child: Icon(icon, size: 60, color: Colors.green),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextHelper.h7.copyWith(color: ColorsForApp.green, fontFamily: boldFont),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextHelper.size17.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: onConfirm,
                child: Text(
                  buttonText,
                  style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldFont),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
