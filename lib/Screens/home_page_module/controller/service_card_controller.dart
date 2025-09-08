import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_enums.dart';
import '../model/service_card_model.dart';

class EmergencyServicesCardController extends GetxController {
  late List<ServiceCardModel> _allCards;
  RxList<ServiceCardModel> serviceCards = <ServiceCardModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  void loadInitialData() {
    _allCards = [
      ServiceCardModel(
        title: "Quick Fix Tyre Service",
        location: "Sector 14, Gurgaon",
        time: "11:00 PM",
        distanceKm: 0.8,
        isOpen: true,
        responseTime: "15 mins",
        serviceType: "puncture",
      ),
      ServiceCardModel(
        title: "Dont know this service",
        location: "Far Far away",
        time: "10:00 AM",
        distanceKm: 1000.0,
        isOpen: false,
        responseTime: "1000 hours",
        serviceType: "puncture",
      ),
      ServiceCardModel(
        title: "You are sick",
        location: "Heaven",
        time: "12:00 AM",
        distanceKm: 0.0,
        isOpen: true,
        responseTime: "0 secs",
        serviceType: "hospital",
      ),
    ];

    serviceCards.value = [];
  }
  // void filterByServiceType(ServiceType type) {
  //   debugPrint("---------------Filtering cards for serviceType: $type");
  //
  //   List<ServiceCardModel> filtered = _allCards.where((card) => card.serviceType == type).toList();
  //
  //   debugPrint("----------------Filtered cards count: ${filtered.length}");
  //
  //   serviceCards.value = filtered;
  // }

}
