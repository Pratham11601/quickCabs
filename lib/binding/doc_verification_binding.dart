import 'package:get/get.dart';

import '../Screens/document_verification_module/controller/document_verification_controller.dart';

class DocVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocVerifyController>(() => DocVerifyController());
  }
}
