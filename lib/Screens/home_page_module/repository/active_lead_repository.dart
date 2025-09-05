import 'package:own_idea/Screens/home_page_module/model/accept_lead_model.dart';
import 'package:own_idea/Screens/home_page_module/model/active_lead_model.dart';
import '../../../api/api_manager.dart';

class ActiveLeadRepository {
  final APIManager apiManager;
  ActiveLeadRepository(this.apiManager);

  //Active lead api call
  Future<ActiveLeadModel> activeLeadApiCall() async {
    var jsonData = await apiManager.getAPICall(
      url: 'https://quickcabpune.com/dev/api/leads/active?page=1&pageSize=10',
    );
    var response = ActiveLeadModel.fromJson(jsonData);
    return response;
  }
}
