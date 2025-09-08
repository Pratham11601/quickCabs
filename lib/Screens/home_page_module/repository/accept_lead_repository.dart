import '../../../api/api_manager.dart';
import '../model/accept_lead_model.dart';

class AcceptLeadRepository {
  final APIManager apiManager;
  AcceptLeadRepository(this.apiManager);
  Future<AcceptLeadModel> acceptLeadApiCall({required int leadId, required String otp}) async {
    var jsonData = await apiManager.postAPICall(
      url: '/leads/accept',
      params: {
        "leadId": leadId,
        "otp": otp,
      },
    );
    return AcceptLeadModel.fromJson(jsonData);
  }

}
