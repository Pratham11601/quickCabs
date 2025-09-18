import 'package:get/get.dart';

import '../model/help_support_model.dart';

class HelpSupportController extends GetxController {
  var contacts = <HelpSupportData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData(); // Load sample data
  }

  // // Dummy support contacts
  // final contacts = <SupportContact>[
  //   SupportContact(
  //     city: "Delhi",
  //     state: "NCR",
  //     whatsapp: "+919822748229",
  //     phone: "+917972129608",
  //     email: "sonwanejanhavi96@gmail.com",
  //   ),
  //   SupportContact(
  //     city: "Mumbai",
  //     state: "Maharashtra",
  //     whatsapp: "+919876543211",
  //     phone: "+91228765433",
  //     email: "support.mumbai@example.com",
  //   ),
  // ].obs;

// Mock data function
  void loadMockData() {
    var mockData = HelpSupportModel(
      status: 1,
      data: [
        HelpSupportData(
          id: 1,
          state: "Maharashtra",
          createdAt: "2025-09-14",
          updatedAt: "2025-09-14",
          phoneNumbers: [
            PhoneNumbers(id: 1, phoneNumber: "9876543210", helpsupportdetailId: 1),
            PhoneNumbers(id: 2, phoneNumber: "9123456780", helpsupportdetailId: 1),
          ],
        ),
        HelpSupportData(
          id: 2,
          state: "Karnataka",
          createdAt: "2025-09-14",
          updatedAt: "2025-09-14",
          phoneNumbers: [
            PhoneNumbers(id: 3, phoneNumber: "9988776655", helpsupportdetailId: 2),
          ],
        ),
      ],
    );

    contacts.value = mockData.data ?? [];
  }
}
