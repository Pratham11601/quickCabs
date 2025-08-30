import 'dart:ui';

import '../../../utils/app_enums.dart';

class ServiceCardModel {
  final String title;
  final String location;
  final String time;
  final double distanceKm;
  final bool isOpen;
  final String responseTime;
  final String serviceType;

  ServiceCardModel({
    required this.title,
    required this.location,
    required this.time,
    required this.distanceKm,
    required this.isOpen,
    required this.responseTime,
    required this.serviceType,
  });
}
