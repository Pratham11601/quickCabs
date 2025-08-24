import 'package:get/get.dart';

class MyLeadsController extends GetxController {
  // Active & Completed leads
  var activeLeads = <Map<String, dynamic>>[].obs;
  var completedLeads = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLeads();
  }

  // Dummy data loader (replace with API later)
  void loadLeads() {
    activeLeads.assignAll([
      {
        "from": "Connaught Place",
        "to": "IGI Airport",
        "price": "850",
        "carType": "Sedan",
        "distance": "24.5 km",
        "date": "2025-08-08",
        "time": "14:30",
        "phone": "+91 9876543210",
        "pin": "5623",
        "note": "Premium customer, AC required, luggage space needed"
      },
      {
        "from": "Gurgaon",
        "to": "Cyber Hub",
        "price": "300",
        "carType": "Hatchback",
        "distance": "8.2 km",
        "date": "2025-08-08",
        "time": "15:00",
        "phone": "+91 9876543211",
        "pin": "5634",
        "note": "Return trip possible"
      },
    ]);

    completedLeads.assignAll([
      {
        "from": "Noida Sector 62",
        "to": "Greater Noida",
        "price": "650",
        "carType": "SUV",
        "distance": "18.8 km",
        "date": "2025-08-08",
        "time": "16:15",
        "phone": "+91 9876543212",
        "pin": "6041",
        "note": "Family trip, child seat available"
      },
    ]);
  }
}
