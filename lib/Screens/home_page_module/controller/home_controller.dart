import 'package:get/get.dart';
import 'package:QuickCab/Screens/home_page_module/model/check_profile_completion_model.dart';
import 'package:QuickCab/Screens/home_page_module/repository/home_repository.dart';

import '../../../api/api_manager.dart';

class HomeController extends GetxController {
  HomeRepository authRepository = HomeRepository(APIManager());

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
}
