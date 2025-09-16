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
import '../model/banner_model.dart';
import '../repository/active_lead_repository.dart';

class HomeController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());
  ActiveLeadRepository activeLeadRepository = ActiveLeadRepository(APIManager());

  @override
  void onInit() {
    super.onInit();
    fetchActiveLeads(1);
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
  var isFilterApplied = false.obs;

  // Future<void> fetchLeads() async {
  //   try {
  //     isLoading.value = true;
  //     errorMsg.value = '';
  //
  //     await Future.delayed(const Duration(milliseconds: 500)); // fake delay
  //
  //     leads.assignAll([
  //       {
  //         'name': 'Amit Singh',
  //         'from': 'Connaught Place',
  //         'to': 'IGI Airport',
  //         'price': 850,
  //         'distance': '24.5 km',
  //         'time': '14:30',
  //       },
  //       {
  //         'name': 'Priya Sharma',
  //         'from': 'Gurgaon',
  //         'to': 'Cyber Hub',
  //         'price': 300,
  //         'distance': '8.2 km',
  //         'time': '15:00',
  //       },
  //       {
  //         'name': 'Mohammed Ali',
  //         'from': 'Noida',
  //         'to': 'Greater Noida',
  //         'price': 650,
  //         'distance': '18.8 km',
  //         'time': '16:15',
  //       },
  //       {
  //         'name': 'Sopan',
  //         'from': 'Pune',
  //         'to': 'Mumbai',
  //         'price': 690,
  //         'distance': '11.1 km',
  //         'time': '12:15',
  //       },
  //     ]);
  //   } catch (e) {
  //     errorMsg.value = 'Failed to load rides';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Button actions
  void declineLiveLead(int index) {
    if (index >= 0 && index < liveLeads.length) liveLeads.removeAt(index);
  }

  void acceptLiveLead(int index) {
    if (index >= 0 && index < liveLeads.length) {
      final lead = liveLeads[index];
      // TODO: call accept API / navigate with `lead`
    }
  }

  RxList<String> emergencyServiceList = <String>[].obs;

  ///active api logic method and variables
  RxList<Post> activeLeads = <Post>[].obs;

  Future<ActiveLeadModel> fetchActiveLeads(dynamic pageNumber) async {
    try {
      isLoadingActiveLeads.value = true;
      errorMsg.value = '';
      final response = await activeLeadRepository.activeLeadApiCall(pageNumber);
      debugPrint('Fetched leads count: ${response.posts.length}');
      activeLeads.assignAll(response.posts);
      filteredActiveLeads.clear(); // 👈 reset filter results
      isFilterApplied.value = false;

      return response;
    } catch (e) {
      errorMsg.value = 'Failed to load active leads';
      debugPrint('Error fetching leads: $e');
      return ActiveLeadModel(posts: []);
    } finally {
      isLoadingActiveLeads.value = false;
    }
  }

  //    RxList<Post> activeList = <Post>[].obs;

  // Future<ActiveLeadModel?> fetchActiveLead(int pageNumber) async {
  //   try {
  //     isLoading.value = true;
  //     final response = await activeLeadRepository.activeLeadApiCall(pageNumber);
  //     if (response.status == true) {
  //       final activeListModel = NewsModel.fromJson(response);
  //       if (newsModel.result != null) {
  //         newsList.addAll(newsModel.result!);
  //       }
  //       isLoading.value = false;
  //       logger.i("News list retrieved successfully: $response");

  //       return newsModel;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     logger.e("News api failed. Please try again.");
  //     return null;
  //   }
  // }

  void applyFilter() {
    filteredActiveLeads.assignAll(activeLeads.where((lead) {
      final matchesFrom = fromLocation.value.isEmpty || (lead.locationFrom ?? "").toLowerCase().contains(fromLocation.value.toLowerCase());
      final matchesTo = toLocation.value.isEmpty || (lead.toLocation ?? "").toLowerCase().contains(toLocation.value.toLowerCase());
      return matchesFrom && matchesTo;
    }).toList());

    isFilterApplied.value = true; // 👈 show filtered list
  }

  void clearFilter() {
    fromLocation.value = "";
    toLocation.value = "";
    filteredActiveLeads.clear();
    isFilterApplied.value = false; // 👈 back to full list
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

  Future<LiveLeadModel> fetchLiveLeads(dynamic pageNumber) async {
    try {
      isLoadingLiveLeads.value = true;
      final response = await activeLeadRepository.liveLeadApiCall(pageNumber);
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

  void clearDriverAvailability() {
    carController.clear();
    locationController.clear();
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    fromTime.value = const TimeOfDay(hour: 9, minute: 0);
    toTime.value = const TimeOfDay(hour: 18, minute: 0);
  }
}
