import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_colors.dart'; // your app colors
import '../utils/text_styles.dart'; // where TextHelper lives

class AppDateTimePicker {
  /// 📅 Reusable Date Picker
  static Future<DateTime?> pickDate(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              headerHelpStyle: TextHelper.h6.copyWith(fontFamily: semiBoldFont),
              headerHeadlineStyle: TextHelper.h4.copyWith(fontFamily: boldFont),
              dayStyle: TextHelper.size18.copyWith(fontFamily: regularFont),
              weekdayStyle: TextHelper.size16.copyWith(fontFamily: semiBoldFont),
              yearStyle: TextHelper.size18.copyWith(fontFamily: regularFont),
              todayBackgroundColor: MaterialStateProperty.all(ColorsForApp.primaryColor.withOpacity(0.2)),
              todayForegroundColor: MaterialStateProperty.all(ColorsForApp.primaryColor),
              rangeSelectionBackgroundColor: ColorsForApp.primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextHelper.size18.copyWith(fontFamily: semiBoldFont),
                foregroundColor: ColorsForApp.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// ⏰ Reusable Time Picker
  static Future<TimeOfDay?> pickTime(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              helpTextStyle: TextHelper.h6.copyWith(fontFamily: semiBoldFont),
              dialTextStyle: TextHelper.size20.copyWith(fontFamily: boldFont),
              hourMinuteTextStyle: TextHelper.h4.copyWith(fontFamily: boldFont),
              dayPeriodTextStyle: TextHelper.size18.copyWith(fontFamily: semiBoldFont),
              entryModeIconColor: ColorsForApp.primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextHelper.size18.copyWith(fontFamily: semiBoldFont),
                foregroundColor: ColorsForApp.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// 🕒 Format TimeOfDay → "HH:mm:ss"
  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm:ss').format(dt);
  }
}
