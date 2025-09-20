import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
  'quick_cab_channel', // id
  'QuickCab Notifications', // name
  description: 'This channel is used for QuickCab notifications.',
  importance: Importance.high,
);
