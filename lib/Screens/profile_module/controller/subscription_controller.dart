import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:own_idea/Screens/profile_module/model/create_order_model.dart';
import 'package:own_idea/Screens/profile_module/model/packages_model.dart';
import 'package:get/get.dart';
import 'package:own_idea/Screens/profile_module/model/recharge_razor_model.dart';
import 'package:own_idea/Screens/profile_module/profile_repository.dart';

import '../../../api/api_manager.dart';
import '../../../widgets/snackbar.dart';

class SubscriptionController extends GetxController {

  ProfileRepository profileRepository = ProfileRepository(APIManager());

  // Package  api
  Rx<PackagesModel> packagesModelResponse = PackagesModel().obs;

  Future<bool> packagesAPI() async {
    try {
      PackagesModel packagesModel = await profileRepository
          .getPackagesDetailsApiCall();
      if (packagesModel.status != null && packagesModel.status != 0) {
        packagesModelResponse.value = packagesModel;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
      return false;
    }
  }


  // Create Order  api
  Rx<CreateOrderModel> createOrderModelResponse = CreateOrderModel().obs;

  Future<bool> createOrderAPI() async {
    try {
      CreateOrderModel createOrderModel = await profileRepository.createOrderApiCall(
          params: {
            "planId": "",
         });
      if (createOrderModel.status != null && createOrderModel.status != 0) {
        createOrderModelResponse.value = createOrderModel;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
      return false;
    }
  }



  // Recharge Razor api
  Rx<RechargeRazorModel> rechargeRazorModelResponse = RechargeRazorModel().obs;

  Future<bool> rechargeRazorAPI() async {
    try {
      RechargeRazorModel rechargeRazorModel = await profileRepository.rechargeRazorApiCall(
          params: {
            "planId": "",
            "order_id": "order_RECSpOobJT5KSk",
            "payment_id": "Front end pe genereate hogha"
          });
      if (rechargeRazorModel.status != null && rechargeRazorModel.status != 0) {
        rechargeRazorModelResponse.value = rechargeRazorModel;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ShowSnackBar.error(message: e.toString());
      return false;
    }
  }

}