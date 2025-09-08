
import '../../../api/api_manager.dart';
import '../model/mylead_model.dart';

class MyLeadRepository
{
  final APIManager apiManager;
  MyLeadRepository(this.apiManager);

  //My lead api
  Future<MyLeadModel> myLeadApicall()async
  {
    var jsonData = await apiManager.getAPICall(
        url: '/leads/my-leads?page=1&pageSize=10'
    );
    var response = MyLeadModel.fromJson(jsonData);
    return response;
  }

}