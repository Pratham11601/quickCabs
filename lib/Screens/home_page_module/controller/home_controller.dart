import 'dart:async';

import 'package:QuickCab/Screens/history_module/lead_history_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/check_profile_completion_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/driver_availability_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/live_lead_model.dart';
import 'package:QuickCab/Screens/home_page_module/repository/home_repository.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/api_manager.dart';
import '../../../utils/date_time_picker.dart';
import '../../profile_module/controller/profile_controller.dart';
import '../home_widgets/accept_lead_popup.dart';
import '../model/active_lead_model.dart';
import '../model/all_live_lead_model.dart';
import '../model/banner_model.dart';
import '../repository/active_lead_repository.dart';

class HomeController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());
  ActiveLeadRepository activeLeadRepository = ActiveLeadRepository(APIManager());
  RxString remainingTimeText = ''.obs;
  RxBool is24hrsCompleted = false.obs;
  Timer? countdownTimer;

  RxInt userId = 0.obs;
  final ProfileController profileController = Get.find<ProfileController>();
// make paging controller accessible to other screens
  PagingController<int, Post>? globalActiveLeadsPagingController;
  void start24HourCountdown(String updatedAt) {
    final updatedAtTime = DateTime.parse(updatedAt).toLocal();
    countdownTimer?.cancel(); // Cancel old timer if already running

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final elapsed = now.difference(updatedAtTime);
      final remaining = const Duration(hours: 24) - elapsed;

      if (remaining.isNegative) {
        // ✅ Completed
        is24hrsCompleted.value = true;
        remainingTimeText.value = "Verification period completed.";
        timer.cancel();
      } else {
        // ⏳ Still counting
        final hours = remaining.inHours;
        final minutes = remaining.inMinutes.remainder(60);
        final seconds = remaining.inSeconds.remainder(60);
        remainingTimeText.value = "${hours}h ${minutes}m ${seconds}s remaining";
      }
    });
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
    fetchNews();
  }

  /// Emergency services list (can come from API later)
  final emergencyServices = [
    {'title': 'Puncture', 'icon': '🛠️'},
    {'title': 'Hospital', 'icon': '🏥'},
    {'title': 'Hotel', 'icon': '🏨'},
    {'title': 'Cab', 'icon': '🚕'},
  ].obs;

  // final liveLeads = <Map<String, dynamic>>[].obs;

  RxBool isKycCompleted = false.obs;
  Future<bool> checkProfileCompletion() async {
    try {
      CheckProfileCompletionModel checkProfileCompletionModel = await authRepository.checkProfileCompletionApiCall();
      if (checkProfileCompletionModel.status == true) {
        isKycCompleted.value = checkProfileCompletionModel.isComplete ?? false;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  ///cards logic and variable
  final isLoading = false.obs;

  // Loading states
  var isLoadingActiveLeads = false.obs;
  var isLoadingLiveLeads = false.obs;

  final errorMsg = ''.obs;
  int _page = 1;
  bool hasMore = true;
  RxInt selectedIndex = 0.obs;

  // New
  RxList<Post> filteredActiveLeads = <Post>[].obs;
  var fromLocation = "".obs;
  var toLocation = "".obs;
  final toLocationController = TextEditingController();
  final fromLocationController = TextEditingController();
  RxBool isFilterApplied = false.obs;

  RxList<String> emergencyServiceList = <String>[].obs;

  void applyFilter() {
    isFilterApplied.value = true; // 👈 show filtered list
  }

  void clearFilter() {
    isFilterApplied.value = false;
    toLocationController.clear();
    fromLocationController.clear();
  }

  // String formatDateTime(String? dateTimeString) {
  //   if (dateTimeString == null || dateTimeString.trim().isEmpty) {
  //     return '-'; // or any default placeholder
  //   }
  //
  //   try {
  //     // Try ISO format first (e.g. "2025-10-27T00:00:00Z" or "2025-10-27")
  //     final dateTime = DateTime.parse(dateTimeString);
  //     return DateFormat('dd MMM, yyyy').format(dateTime);
  //   } catch (e) {
  //     try {
  //       // Try MySQL-style format (e.g. "2025-10-27 11:00:00")
  //       final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //       final dateTime = inputFormat.parse(dateTimeString);
  //       return DateFormat('dd MMM, yyyy').format(dateTime);
  //     } catch (e) {
  //       try {
  //         // Try if the date has extra words (e.g. "2025-10-27 at 11")
  //         final cleaned = dateTimeString.split(' ').first;
  //         final dateTime = DateTime.parse(cleaned);
  //         return DateFormat('dd MMM, yyyy').format(dateTime);
  //       } catch (e) {
  //         debugPrint('⚠️ Invalid date format: $dateTimeString');
  //         return dateTimeString; // fallback
  //       }
  //     }
  //   }
  // }

  /// Calculate days from start date and end date
  /// Converts various date formats to 'dd MMM, yyyy'
  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.trim().isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM, yyyy').format(dateTime);
    } catch (e) {
      try {
        final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        final dateTime = inputFormat.parse(dateTimeString);
        return DateFormat('dd MMM, yyyy').format(dateTime);
      } catch (e) {
        debugPrint('⚠️ Invalid date format: $dateTimeString');
        return '-';
      }
    }
  }

  /// Calculates day difference between two formatted dates
  int calculateDays(String start, String end) {
    try {
      if (start == '-' || end == '-' || start.isEmpty || end.isEmpty) return 0;
      final DateFormat formatter = DateFormat('dd MMM, yyyy');
      final DateTime startDate = formatter.parse(start);
      final DateTime endDate = formatter.parse(end);
      return endDate.difference(startDate).inDays + 1;
    } catch (e) {
      debugPrint('⚠️ Error parsing date: $e');
      return 0;
    }
  }

  String formatTime(String time) {
    try {
      // Input format: HH:mm:ss (24-hour)
      final inputFormat = DateFormat("HH:mm:ss");
      final dateTime = inputFormat.parse(time);

      // Output format: hh:mm a (12-hour with AM/PM)
      final outputFormat = DateFormat("hh:mm a");
      return outputFormat.format(dateTime);
    } catch (e) {
      return time; // fallback agar parse fail ho jaye
    }
  }

  ///accept or booked logic
  Future<void> acceptLead(Post lead) async {
    await Get.dialog(
      AcceptLeadOtpPopup(
        sharedBy: lead.vendorFullname ?? '',
        route: "${lead.locationFrom ?? ''} → ${lead.toLocation ?? ''}",
        fare: double.tryParse(lead.fare ?? '0')?.toInt() ?? 0,
        leadId: lead.id!,
      ),
      barrierDismissible: false,
    );
  }

  // Open WhatsApp chat
  Future<void> openWhatsApp(String number) async {
    // Remove + if present
    String formattedNumber = number.replaceAll("+", "");
    final whatsappUrl = Uri.parse("https://wa.me/$formattedNumber");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open WhatsApp");
    }
  }

  // Call a number
  Future<void> makeCall(String number) async {
    final callUrl = Uri.parse("tel:$number");
    if (await canLaunchUrl(callUrl)) {
      await launchUrl(callUrl);
    } else {
      Get.snackbar("Error", "Could not make a call");
    }
  }

  /// Share Lead
  void shareLead(Post lead) async {
    // 🕓 Handle date and time based on trip type
    String dateSection;

    if (lead.tripType == 0 || lead.tripType == 2) {
      //One-way / Rental Trip  → show single date + time
      final date = formatDateTime(lead.date);
      final time = lead.time ?? '-';
      dateSection = '*Date*: $date | $time';
    } else {
      // Return Trip → show start and end date
      final startDate = formatDateTime(lead.startDate);
      final startTime = lead.time ?? '-';
      final endDate = formatDateTime(lead.endDate);
      dateSection = '*Start*: $startDate , $startTime | *End*: $endDate';
    }

    // Trip type
    String tripTypeText;
    switch (lead.tripType) {
      case 0:
        tripTypeText = 'Oneway Trip';
        break;
      case 1:
        tripTypeText = 'Return Trip';
        break;
      case 2:
        tripTypeText = 'Rented Trip';
        break;
      default:
        tripTypeText = '-';
    }

    // Build rental duration section only if trip type = 2
    final rentalDurationSection = lead.tripType == 2 ? '*Rental Duration*: ${lead.rentalDuration ?? '-'}\n\n' : '';
    // 🧾 Build WhatsApp message
    final message = Uri.encodeComponent(
      '*QuickCab Booking Details*\n\n'
      '*Name*: ${lead.vendorName ?? '-'}\n\n'
      '$dateSection\n\n'
      '*From*: ${lead.locationFromArea ?? '-'}\n\n'
      '*To*: ${lead.toLocationArea ?? '-'}\n\n'
      '*Car*: ${lead.carModel ?? '-'}\n\n'
      '*Trip Type*: ${tripTypeText ?? '-'}\n\n'
      '*Toll Tax*: ${lead.tollTax ?? '-'}\n\n'
      '*Carrier*: ${lead.carrier ?? '-'}\n\n'
      '*Fuel Type*: ${lead.fuelType ?? '-'}\n\n'
      '${rentalDurationSection.isNotEmpty ? rentalDurationSection : ""}'
      '*Amount*: ₹${lead.fare ?? '-'}\n\n'
      '*Contact*: ${lead.vendorContact ?? '-'}',
    );

    final whatsappUrl = Uri.parse('https://wa.me/?text=$message');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("⚠️ Could not open WhatsApp");
    }
  }

  // Banners api
  // Banners api
  RxList<FormattedAdvertisements> banners = <FormattedAdvertisements>[].obs; // ✅ correct type
  var isBannerLoading = true.obs;

  void fetchBanners() async {
    try {
      isBannerLoading(true);
      final response = await activeLeadRepository.fetchBannersApiCall();
      if (response.formattedAdvertisements != null) {
        // ✅ Assign list directly
        banners.assignAll(response.formattedAdvertisements!);
        print("banner length: ${banners.length}");
      } else {
        banners.clear(); // in case API returns empty
        print("No banners found");
      }
    } catch (e) {
      debugPrint("Error fetching banners: $e");
    } finally {
      isBannerLoading(false);
    }
  }

  /// Fetch the scrolling news announcement

  var isNewsLoading = true.obs;
  var announcement = ''.obs; // to store the announcement message
  void fetchNews() async {
    try {
      isNewsLoading(true);

      final response = await activeLeadRepository.fetchNewsApiCall();

      // Example: response.data contains the JSON response body
      if (response != null && response.data != null) {
        final data = response.data;

        if (response.success == true) {
          announcement.value = data!.announcement.toString() ?? '';
          debugPrint("📰 Announcement fetched: ${announcement.value}");
        } else {
          debugPrint("⚠️ No announcement data found.");
          announcement.value = '';
        }
      } else {
        debugPrint("⚠️ Empty response from API.");
        announcement.value = '';
      }
    } catch (e) {
      debugPrint("❌ Error fetching news: $e");
      announcement.value = '';
    } finally {
      isNewsLoading(false);
    }
  }

  /// Driver Availability Module ///
  // Controllers for text inputs
  final carController = TextEditingController();
  final locationController = TextEditingController();

  // Date & Time fields (observable)
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var fromTime = TimeOfDay(hour: 9, minute: 0).obs;
  var toTime = TimeOfDay(hour: 18, minute: 0).obs;

  // Pick date using reusable AppDateTimePicker
  Future<void> pickDate(BuildContext context, bool isFrom) async {
    final picked = await AppDateTimePicker.pickDate(
      context,
      initialDate: isFrom ? fromDate.value : toDate.value,
    );

    if (picked != null) {
      if (isFrom) {
        fromDate.value = picked;
      } else {
        toDate.value = picked;
      }
    }
  }

  // Pick time using reusable AppDateTimePicker
  Future<void> pickTime(BuildContext context, bool isFrom) async {
    final picked = await AppDateTimePicker.pickTime(
      context,
      initialTime: isFrom ? fromTime.value : toTime.value,
    );

    if (picked != null) {
      if (isFrom) {
        fromTime.value = picked;
      } else {
        toTime.value = picked;
      }
    }
  }

  // Driver availability post api
  Rx<DriverAvailabilityModel> driverAvailabilityModel = DriverAvailabilityModel().obs;

  Future<bool> postDriverAvailability(BuildContext context, {bool isLoaderShow = true}) async {
    final params = {
      "car": carController.text.trim(),
      "location": locationController.text.trim(),
      "from_date": DateFormat('yyyy-MM-dd').format(fromDate.value),
      "from_time": AppDateTimePicker.formatTimeOfDay(fromTime.value),
      "to_date": DateFormat('yyyy-MM-dd').format(toDate.value),
      "to_time": AppDateTimePicker.formatTimeOfDay(toTime.value),
    };

    try {
      isLoading.value = true;

      final response = await authRepository.postDriverAvailabilityApiCall(
        isLoaderShow: isLoaderShow,
        params: params,
      );

      driverAvailabilityModel.value = response;

      if (driverAvailabilityModel.value.status == 1) {
        return true;
      } else {
        ShowSnackBar.error(
          title: 'Error',
          message: driverAvailabilityModel.value.message ?? 'Failed to share availability',
        );
        return false;
      }
    } catch (e) {
      ShowSnackBar.error(
        title: 'Error',
        message: 'Something went wrong. Please try again.',
      );
      return false;
    } finally {
      isLoading.value = false; // ✅ only reset loading, no return here
    }
  }

  // Fetch Live Lead api

  ///live api logic method and variables
  RxList<LiveLeadData> liveLeads = <LiveLeadData>[].obs;
  RxList<AllLiveLeadData> allLiveLeads = <AllLiveLeadData>[].obs;
  var showMyAvailability = false.obs;
  RxInt driversCount = 0.obs;

  Future<LiveLeadModel> fetchMyAvailability(dynamic pageNumber) async {
    try {
      isLoadingLiveLeads.value = true;
      final response = await activeLeadRepository.myAvailabilityApiCall(pageNumber);
      debugPrint('Fetched leads count: ${response.data!.length}');
      liveLeads.assignAll(response.data!);
      return response;
    } catch (e) {
      errorMsg.value = 'Failed to load active leads';
      debugPrint('Error fetching leads: $e');
      return LiveLeadModel(data: []);
    } finally {
      isLoadingLiveLeads.value = false;
    }
  }

  ///active api logic method and variables
  RxList<Post> activeLeads = <Post>[].obs;
  RxList<Post> filteredLeads = <Post>[].obs;
  RxList<Leads> leadsHistory = <Leads>[].obs;

  Future<ActiveLeadModel> fetchActiveLeads(
    dynamic pageNumber, {
    String? fromLocation,
    String? toLocation,
  }) async {
    try {
      isLoadingActiveLeads.value = true;
      errorMsg.value = '';

      // Use explicit parameters if provided, otherwise fallback to controller's text fields
      final from = (fromLocation ?? fromLocationController.text ?? '').trim();
      final to = (toLocation ?? toLocationController.text ?? '').trim();

      final response = await activeLeadRepository.activeLeadApiCall(pageNumber, from, to);
      debugPrint('Fetched leads count: ${response.posts!.length}');
      activeLeads.clear();
      activeLeads.assignAll(response.posts ?? []);
      return response;
    } catch (e) {
      errorMsg.value = 'Failed to load active leads';
      debugPrint('Error fetching leads: $e');
      return ActiveLeadModel(posts: []);
    } finally {
      isLoadingActiveLeads.value = false;
    }
  }

  Future<LeadHistoryModel> fetchLeadsHistory(dynamic pageNumber) async {
    try {
      isLoadingActiveLeads.value = true;
      errorMsg.value = '';

      final response = await activeLeadRepository.leadHistoryApiCall(pageNumber, fromLocationController.text, toLocationController.text);
      debugPrint('History leads count: ${response.leads?.length}');

      leadsHistory.assignAll(response.leads!);
      return response;
    } catch (e) {
      errorMsg.value = 'Failed to load active leads';
      debugPrint('Error fetching leads: $e');
      return LeadHistoryModel(leads: []);
    } finally {
      isLoadingActiveLeads.value = false;
    }
  }

  Future<AllLiveLeadModel> fetchAllDriversAvailability(dynamic pageNumber) async {
    try {
      isLoadingLiveLeads.value = true;
      final response = await activeLeadRepository.allDriverAvailabilityApiCall(pageNumber);
      debugPrint('Fetched leads count: ${response.data!.length}');
      allLiveLeads.assignAll(response.data!);
      driversCount.value = response.pagination!.totalCount!;
      return response;
    } catch (e) {
      errorMsg.value = 'Failed to load active leads';
      debugPrint('Error fetching leads: $e');
      return AllLiveLeadModel(data: []);
    } finally {
      isLoadingLiveLeads.value = false;
    }
  }

// Update driver availability
  Rx<DriverAvailabilityModel> updateDriverAvailabilityModel = DriverAvailabilityModel().obs;

  Future<bool> updateDriverAvailability({
    bool isLoaderShow = true,
    required int status,
    required int leadId,
    required String car,
    required String location,
    required DateTime fromDate,
    required TimeOfDay fromTime,
    required DateTime toDate,
    required TimeOfDay toTime,
  }) async {
    final params = {
      "car": car,
      "location": location,
      "from_date": DateFormat('yyyy-MM-dd').format(fromDate),
      "from_time": AppDateTimePicker.formatTimeOfDay(fromTime),
      "to_date": DateFormat('yyyy-MM-dd').format(toDate),
      "to_time": AppDateTimePicker.formatTimeOfDay(toTime),
      "status": status
    };

    try {
      isLoading.value = true;

      final response = await authRepository.updateDriverAvailabilityApiCall(isLoaderShow: isLoaderShow, params: params, leadId: leadId);

      updateDriverAvailabilityModel.value = response;

      if (updateDriverAvailabilityModel.value.status == 1) {
        return true;
      } else {
        ShowSnackBar.error(
          title: 'Error',
          message: updateDriverAvailabilityModel.value.message ?? 'Failed to update availability',
        );
        return false;
      }
    } catch (e) {
      ShowSnackBar.error(
        title: 'Error',
        message: 'Something went wrong. Please try again later.',
      );
      return false;
    } finally {
      isLoading.value = false; // ✅ only reset loading, no return here
    }
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    // Expecting format "HH:mm:ss"
    final parts = timeString.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void clearDriverAvailability() {
    carController.clear();
    locationController.clear();
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    fromTime.value = const TimeOfDay(hour: 9, minute: 0);
    toTime.value = const TimeOfDay(hour: 18, minute: 0);
  }
}
