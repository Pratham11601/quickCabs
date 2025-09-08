import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../api/api_manager.dart';
import '../../../routes/routes.dart';
import '../repository/post_lead_repository.dart';

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
    // pickupController.dispose();
    // dropController.dispose();
    super.onClose();
  }
  //------------------api logic----------------
  final PostLeadRepository postLeadRepository = PostLeadRepository(APIManager());

  Future<void> submitRideLead() async {
    final params = {
      "date": selectedDate.value == null ? "" : DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      "time": selectedTime.value == null ? "" : selectedTime.value!.format(Get.context!),
      "location_from": pickupController.text.trim(),
      "location_from_area": "",
      "to_location": dropController.text.trim(),
      "to_location_area": "",
      "car_model": selectedVehicleIndex.value != null ? vehicles[selectedVehicleIndex.value!]["name"] : "",
      "add_on": "",
      "fare": int.tryParse(fareController.text.trim()) ?? 0,
      "cab_number": "",
      "vendor_contact": "",
    };

    try {
      final response = await postLeadRepository.postLeadApiCall(params: params);
      if (response.status == true) {
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
        Get.snackbar('Error', response.message ?? 'Failed to share lead');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
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
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.black),
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
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
