import 'package:QuickCab/Screens/home_page_module/model/check_profile_completion_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/driver_availability_model.dart';
import 'package:QuickCab/Screens/home_page_module/model/live_lead_model.dart';
import 'package:QuickCab/Screens/home_page_module/repository/home_repository.dart';
import 'package:QuickCab/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/api_manager.dart';
import '../../../utils/date_time_picker.dart';
import '../home_widgets/accept_lead_popup.dart';
import '../model/active_lead_model.dart';

import '../model/all_live_lead_model.dart';
import '../model/banner_model.dart';
import '../repository/active_lead_repository.dart';

class HomeController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());
  ActiveLeadRepository activeLeadRepository =
      ActiveLeadRepository(APIManager());

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
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
      CheckProfileCompletionModel checkProfileCompletionModel =
          await authRepository.checkProfileCompletionApiCall();
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

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(dateTime);
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
  Future<void> acceptLead(int index) async {
    if (index < 0 || index >= activeLeads.length) return;
    final lead = activeLeads[index];

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

  // Banners api
  // Banners api
  var banners = <BannerModel>[].obs; // ✅ correct type
  var isBannerLoading = true.obs;

  void fetchBanners() async {
    try {
      isBannerLoading(true);
      final response = await activeLeadRepository.fetchBannersApiCall();
      banners.assignAll(response); // ✅ directly assign list
    } catch (e) {
      debugPrint("Error fetching banners: $e");
    } finally {
      isBannerLoading(false);
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
  Rx<DriverAvailabilityModel> driverAvailabilityModel =
      DriverAvailabilityModel().obs;

  Future<bool> postDriverAvailability(BuildContext context,
      {bool isLoaderShow = true}) async {
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
          message: driverAvailabilityModel.value.message ??
              'Failed to share availability',
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
      final response =
          await activeLeadRepository.myAvailabilityApiCall(pageNumber);
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

  Future<ActiveLeadModel> fetchActiveLeads(dynamic pageNumber) async {
    try {
      isLoadingActiveLeads.value = true;
      errorMsg.value = '';
      final response = await activeLeadRepository.activeLeadApiCall(
          pageNumber, fromLocation.value, toLocation.value);
      debugPrint('Fetched leads count: ${response.posts.length}');
      activeLeads.assignAll(response.posts);
      filteredActiveLeads.clear(); // 👈 reset filter results

      return response;
    } catch (e) {
      errorMsg.value = 'Failed to load active leads';
      debugPrint('Error fetching leads: $e');
      return ActiveLeadModel(posts: []);
    } finally {
      isLoadingActiveLeads.value = false;
    }
  }

  Future<AllLiveLeadModel> fetchAllDriversAvailability(
      dynamic pageNumber) async {
    try {
      isLoadingLiveLeads.value = true;
      final response =
          await activeLeadRepository.allDriverAvailabilityApiCall(pageNumber);
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
  Rx<DriverAvailabilityModel> updateDriverAvailabilityModel =
      DriverAvailabilityModel().obs;

  Future<bool> updatetDriverAvailability({
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

      final response = await authRepository.updateDriverAvailabilityApiCall(
          isLoaderShow: isLoaderShow, params: params, leadId: leadId);

      updateDriverAvailabilityModel.value = response;

      if (updateDriverAvailabilityModel.value.status == 1) {
        return true;
      } else {
        ShowSnackBar.error(
          title: 'Error',
          message: updateDriverAvailabilityModel.value.message ??
              'Failed to update availability',
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
