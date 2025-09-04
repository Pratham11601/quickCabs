import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../model/mylead_model.dart';
import '../repository/mylead_repository.dart';
import '../../../api/api_manager.dart';

class MyLeadsController extends GetxController {
  var isLoading = false.obs;
  var activeLeads = <Lead>[].obs;
  var completedLeads = <Lead>[].obs;
  var filteredActiveLeads = <Lead>[].obs;
  var filteredCompletedLeads = <Lead>[].obs;

  final MyLeadRepository repository = MyLeadRepository(APIManager());

  @override
  void onInit() {
    super.onInit();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    try {
      isLoading(true);
      final response = await repository.myLeadApicall();
      activeLeads.assignAll(response.leads.where((lead) => lead.isActive == true).toList());
      completedLeads.assignAll(response.leads.where((lead) => lead.isActive == false).toList());

      filteredActiveLeads.assignAll(activeLeads);
      filteredCompletedLeads.assignAll(completedLeads);
    } catch (e) {
      print('Error loading leads: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterLeads(String query) {
    if (query.isEmpty) {
      filteredActiveLeads.assignAll(activeLeads);
      filteredCompletedLeads.assignAll(completedLeads);
    } else {
      filteredActiveLeads.assignAll(activeLeads.where((lead) =>
      (lead.locationFrom ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (lead.toLocation ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (lead.fare ?? '').contains(query)).toList());

      filteredCompletedLeads.assignAll(completedLeads.where((lead) =>
      (lead.locationFrom ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (lead.toLocation ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (lead.fare ?? '').contains(query)).toList());
    }
  }
}
