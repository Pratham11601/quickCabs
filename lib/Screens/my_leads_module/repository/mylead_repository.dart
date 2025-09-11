import '../../../api/api_manager.dart';
import '../model/edit_lead_model.dart';
import '../model/mylead_model.dart';

class MyLeadRepository {
  final APIManager apiManager;
  MyLeadRepository(this.apiManager);

  //My lead api
  Future<MyLeadModel> myLeadApicall() async {
    var jsonData = await apiManager.getAPICall(url: '/leads/my-leads?page=1&pageSize=10');
    var response = MyLeadModel.fromJson(jsonData);
    return response;
  }

  Future<EditLeadModel> editLeadApiCall({
    required Map<String, dynamic> params,
    bool isLoaderShow = true,
    required int leadId,
  }) async {
    var jsonData = await apiManager.patchAPICall(
      url: '/leads/edit-lead/$leadId',
      params: params,
    );
    return EditLeadModel.fromJson(jsonData);
  }
}
