import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/support_contact_model.dart';

class HelpSupportController extends GetxController {
  // Dummy support contacts
  final contacts = <SupportContact>[
    SupportContact(
      city: "Delhi",
      state: "NCR",
      whatsapp: "+919822748229",
      phone: "+917972129608",
      email: "sonwanejanhavi96@gmail.com",
    ),
    SupportContact(
      city: "Mumbai",
      state: "Maharashtra",
      whatsapp: "+919876543211",
      phone: "+91228765433",
      email: "support.mumbai@example.com",
    ),
  ].obs;

  // Open WhatsApp chat
  Future<void> openWhatsApp(String number) async {
    // Remove + if present
    String formattedNumber = number.replaceAll("+", "");
    final whatsappUrl = Uri.parse("https://wa.me/$formattedNumber");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open WhatsApp");
    }
  }

  // Call a number
  Future<void> makeCall(String number) async {
    final callUrl = Uri.parse("tel:$number");
    if (await canLaunchUrl(callUrl)) {
      await launchUrl(callUrl);
    } else {
      Get.snackbar("Error", "Could not make a call");
    }
  }

  // Send email
  Future<void> sendEmail(String email) async {
    final emailUrl = Uri.parse("mailto:$email");
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    } else {
      Get.snackbar("Error", "Could not open Email");
    }
  }
}
