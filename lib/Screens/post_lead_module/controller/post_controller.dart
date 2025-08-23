import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/routes.dart';

class PostController extends GetxController {
  // ── Stepper ──────────────────────────────────────────────────────────────────
  final RxInt step = 1.obs; // 1..3

  // ── Route Details ────────────────────────────────────────────────────────────
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();

  // ── Trip Type ────────────────────────────────────────────────────────────────
  final RxString tripType = 'Return Trip'.obs;

  // ── Vehicle & Seat Config ────────────────────────────────────────────────────
  final RxnInt selectedVehicleIndex = RxnInt();
  final RxnInt selectedSeatConfig = RxnInt();

  // If a vehicle needs seat configuration, mark it with "seatConfig": true
  final List<Map<String, dynamic>> vehicles = <Map<String, dynamic>>[
    {"name": "Hatchback", "seats": "4+1", "color": Colors.orange},
    {"name": "Sedan", "seats": "4+1", "color": Colors.blue},
    {"name": "SUV", "seats": "6+1", "color": Colors.green},
    {"name": "Innova Crysta", "seats": "6+1", "color": Colors.amber, "seatConfig": true},
    {"name": "Tempo Traveler", "seats": "", "color": Colors.blue},
    {"name": "Force Urbania", "seats": "", "color": Colors.red},
    {"name": "Mini Bus", "seats": "", "color": Colors.blue},
    {"name": "Bus", "seats": "", "color": Colors.green, "seatConfig": true},
    {"name": "Luxury Cars", "seats": "", "color": Colors.amber},
    {"name": "Only Parcel", "seats": "", "color": Colors.red},
  ];

  // ── Date & Time ──────────────────────────────────────────────────────────────
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();

  String get formattedDate => selectedDate.value == null ? "dd/mm/yyyy" : DateFormat("dd/MM/yyyy").format(selectedDate.value!);

  String formattedTime(BuildContext ctx) => selectedTime.value == null ? "--:--" : selectedTime.value!.format(ctx);

  double get progress => currentStep.value / 3.0;
  String get progressPercentLabel => "${(progress * 100).round()}% Complete";

  // ── Actions ──────────────────────────────────────────────────────────────────
  void selectTripType(String type) {
    tripType.value = type;
    validateForm();
  }

  void validateForm() {
    isFormValid.value = pickupController.text.isNotEmpty && dropController.text.isNotEmpty && tripType.value.isNotEmpty;
  }

  void selectVehicle(int index) {
    selectedVehicleIndex.value = index;
    selectedSeatConfig.value = null; // reset seat choice when vehicle changes
  }

  void selectSeatConfig(int seats) => selectedSeatConfig.value = seats;

  Future<void> pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      initialDate: selectedDate.value ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  fontSizeFactor: 1.2, // increase size by 20%
                ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) selectedDate.value = date;
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay initial = selectedTime.value ?? TimeOfDay.now();
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextStyle: const TextStyle(fontSize: 24),
              helpTextStyle: const TextStyle(fontSize: 18),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) selectedTime.value = time;
  }

  var currentStep = 0.obs;
  var isFormValid = false.obs; // this will control the Next button enabled/disabled

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
  }

  @override
  void onClose() {
    pickupController.dispose();
    dropController.dispose();
    super.onClose();
  }
}
