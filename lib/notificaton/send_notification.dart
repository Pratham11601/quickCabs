import 'dart:convert';

import 'package:QuickCab/notificaton/firebase_messeges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingApi(
      String source, String destination, String price) async {
    String serverKey = await GetServerKey().getServerKeyToken();

    print("Server key => $serverKey");
    String url =
        "https://fcm.googleapis.com/v1/projects/quick-cabs-d3951/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    print('FCM Token  ---  $serverKey');

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("Device key => $fcmToken");

    // Message for topic "all"
    Map<String, dynamic> topicMessage = {
      "message": {
        "topic": "all",
        "notification": {
          "title": "Fare Price:-Rs $price /-  ",
          "body": "$source  🚗   $destination"
        },
        "data": {
          "story_id": "story_12345",
        },
        // "android": {
        //   "priority": "high",
        //   "notification": {
        //     "body": "Fare Price:-Rs ${price} /-  ",
        //     "channel_id": "new_lead_channel",
        //   }
        // }
      }
    };

    // Send to topic
    final http.Response topicResponse = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(topicMessage),
    );

    if (topicResponse.statusCode == 200) {
      print("Notification sent to topic successfully!");
    } else {
      print("Failed to send notification to topic.");
      print("Error: ${topicResponse.body}");
    }

    // Send to specific device
  }
}
