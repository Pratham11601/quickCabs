import 'package:intl/intl.dart';

extension DateTypeExtension on String? {
  // todo instead of doing this, convert that string date in datetime using DateFormatter then use extension on datetime to convert in design format
  String formatDateTime() {
    if (this == null || this!.isEmpty) return 'Invalid Date';
    try {
      DateTime parsedDate = DateTime.parse(this!);

      int day = parsedDate.day;
      String ordinalSuffix;
      if (day >= 11 && day <= 13) {
        ordinalSuffix = 'th';
      } else {
        switch (day % 10) {
          case 1:
            ordinalSuffix = 'st';
            break;
          case 2:
            ordinalSuffix = 'nd';
            break;
          case 3:
            ordinalSuffix = 'rd';
            break;
          default:
            ordinalSuffix = 'th';
        }
      }

      String formattedDate = DateFormat("d'${ordinalSuffix}' MMM yyyy, hh:mm a").format(parsedDate);
      return formattedDate;
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
