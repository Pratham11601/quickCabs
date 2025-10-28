import 'package:QuickCab/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/text_styles.dart';

/// Step Circle Widget
Widget stepCircle(String label, bool active) {
  return Column(
    children: [
      CircleAvatar(
        radius: 8,
        backgroundColor: active ? Colors.white : Colors.white38,
      ),
      const SizedBox(height: 4),
      Text(label, style: TextHelper.size17.copyWith(color: Colors.white, fontFamily: regularFont)),
    ],
  );
}

/// Input Field Widget
Widget buildInputField(
  String title,
  String hint,
  IconData icon,
  Color iconColor,
  TextEditingController controller, {
  bool isNumeric = false,
  ValueChanged<String>? onChanged,
  FocusNode? focusNode,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextHelper.size18.copyWith(fontFamily: semiBoldFont)),
      const SizedBox(height: 6),
      TextFormField(
        focusNode: focusNode,
        keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        controller: controller,
        onChanged: onChanged,
        style: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor),
        decoration: InputDecoration(
          hintText: hint,
          errorStyle: TextHelper.size17.copyWith(fontFamily: regularFont, color: ColorsForApp.red),
          hintStyle: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.subTitleColor),
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your fare amount';
          }
          return null;
        },
      )
    ],
  );
}

/// Date & time input field
Widget buildDateColumn({
  required String title,
  required IconData icon,
  required VoidCallback onTap,
  required String text,
}) {
  return SizedBox(
    width: 28.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextHelper.size17.copyWith(
            fontFamily: semiBoldFont,
            color: ColorsForApp.blackColor,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: onTap,
          child: buildInputBox(icon: icon, text: text),
        ),
      ],
    ),
  );
}

/// Simple input-like box for date/time display (kept local for styling)
Widget buildInputBox({required IconData icon, required String text}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300, width: 2),
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: ColorsForApp.primaryColor),
        const SizedBox(width: 8),
        // 👇 This Expanded fixes the overflow
        Expanded(
          child: Text(
            text,
            style: TextHelper.size18.copyWith(
              color: ColorsForApp.blackColor,
              fontFamily: semiBoldFont,
            ),
            overflow: TextOverflow.ellipsis, // shows "..." if too long
            maxLines: 1, // keeps text single line
            softWrap: false,
          ),
        ),
      ],
    ),
  );
}
