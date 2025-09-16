import 'package:get/get.dart';

import '../../../api/api_manager.dart';
import '../model/vendor_emergency_model.dart';
import '../repository/home_repository.dart';

class EmergencyServicesCardController extends GetxController {
  var vendors = <Vendors>[].obs;
  var isLoading = false.obs;
  var isMoreDataAvailable = true.obs;
  var totalVendors = 0.obs; // store total vendors

  RxInt currentPage = 1.obs;
  final int limit = 10;
  final String category;

  HomeRepository authRepository = HomeRepository(APIManager());
  EmergencyServicesCardController({required this.category});

  @override
  void onInit() {
    super.onInit();
    fetchVendors();
  }

  void fetchVendors() async {
    if (!isMoreDataAvailable.value || isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await authRepository.getVendors(
        category: category,
        page: currentPage.value,
        limit: limit,
      );
      // store total count from API
      if (response.status == 1) {
        totalVendors.value = response.total ?? 0;

        if (response.vendors != null && response.vendors!.isNotEmpty) {
          vendors.addAll(response.vendors!);
          currentPage++;
        } else {
          isMoreDataAvailable.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() {
    if (isMoreDataAvailable.value) {
      fetchVendors();
    }
  }
}
