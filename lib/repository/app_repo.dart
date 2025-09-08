import 'package:flutter/foundation.dart';

import '../api/api_manager.dart';
import '../models/common_model.dart';

class AppRepository {
  AppRepository._();
  static APIManager apiManager = APIManager();


  static Future<RefreshFcmModel> refreshFCMToken({required Map<String, dynamic> params, bool showLoading = false}) async {
    try {
      var response = await apiManager.putAPICall(
        url: '/api/passengers/rewriteToken',
        params: params,
        showLoading: showLoading,
      );
      RefreshFcmModel refreshFcmModel = RefreshFcmModel.fromJson(response);
      return refreshFcmModel;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}