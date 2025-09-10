import 'package:QuickCab/Screens/home_page_module/model/check_profile_completion_model.dart';
import 'package:QuickCab/Screens/home_page_module/repository/home_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/api_manager.dart';
import '../home_widgets/accept_lead_popup.dart';
import '../model/active_lead_model.dart';
import '../repository/active_lead_repository.dart';

class HomeController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());
  ActiveLeadRepository activeLeadRepository = ActiveLeadRepository(APIManager());

  @override
  void onInit() {
    super.onInit();
    fetchActiveLeads();
  }

  /// Emergency services list (can come from API later)
  final emergencyServices = [
    {'title': 'Puncture', 'icon': '🛠️'},
    {'title': 'Hospital', 'icon': '🏥'},
    {'title': 'Hotel', 'icon': '🏨'},
    {'title': 'Cab', 'icon': '🚕'},
  ].obs;

  /// Shared leads (mock data now, replace with API later)
  final leads = [
    {
      'name': 'Amit Singh',
      'price': 850,
      'from': 'Connaught Place',
      'to': 'IGI Airport',
      'car': 'Sedan',
      'distance': '24.5 km',
      'date': '2025-08-08',
      'time': '14:30',
      'phone': '+91 9876543210',
      'note': 'Premium customer, AC required, luggage space needed'
    },
    {
      'name': 'Priya Sharma',
      'price': 300,
      'from': 'Gurgaon',
      'to': 'Cyber Hub',
      'car': 'Hatchback',
      'distance': '8.2 km',
      'date': '2025-08-08',
      'time': '15:00',
      'phone': '+91 9876543211',
      'note': 'Return trip possible'
    },
    {
      'name': 'Mohammed Ali',
      'price': 650,
      'from': 'Noida',
      'to': 'Greater Noida',
      'car': 'SUV',
      'distance': '18.8 km',
      'date': '2025-08-08',
      'time': '16:15',
      'phone': '+91 9876543212',
      'note': 'Family trip, child seat available'
    }
  ].obs;
  final liveLeads = <Map<String, dynamic>>[].obs;

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
  var isFilterApplied = false.obs; // 👈 new flag

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
  Future<void> fetchLiveLeads() async {
    try {
      isLoadingLiveLeads.value = true;
      errorMsg.value = '';
      await Future.delayed(const Duration(milliseconds: 400)); // demo delay

      liveLeads.assignAll([
        {
          'name': 'Amit Singh',
          'from': 'Connaught Place',
          'to': 'IGI Airport',
          'price': 850,
          'distance': '24.5 km',
          'time': '14:30',
        },
        {
          'name': 'Priya Sharma',
          'from': 'Gurgaon',
          'to': 'Cyber Hub',
          'price': 300,
          'distance': '8.2 km',
          'time': '15:00',
        },
        {
          'name': 'Mohammed Ali',
          'from': 'Noida',
          'to': 'Greater Noida',
          'price': 650,
          'distance': '18.8 km',
          'time': '16:15',
        },
        {
          'name': 'Sopan',
          'from': 'Pune',
          'to': 'Mumbai',
          'price': 69,
          'distance': '11.1 km',
          'time': '12:15',
        },
        {
          'name': 'Topan',
          'from': 'Katraj',
          'to': 'Karve nagar',
          'price': 69,
          'distance': '11.1 km',
          'time': '12:15',
        },
      ]);
    } catch (e) {
      errorMsg.value = 'Failed to load rides';
    } finally {
      isLoadingLiveLeads.value = false;
    }
  }

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

  ///active api logic method and veriavble
  RxList<Post> activeLeads = <Post>[].obs;

  Future<void> fetchActiveLeads() async {
    try {
      isLoadingActiveLeads.value = true;
      errorMsg.value = '';
      final response = await activeLeadRepository.activeLeadApiCall();
      debugPrint('Fetched leads count: ${response.posts.length}');
      activeLeads.assignAll(response.posts);
      filteredActiveLeads.clear(); // 👈 reset filter results
      isFilterApplied.value = false;
    } catch (e) {
      errorMsg.value = 'Failed to load active leads';
      debugPrint('Error fetching leads: $e');
    } finally {
      isLoadingActiveLeads.value = false;
    }
  }

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
}
