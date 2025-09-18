import 'package:QuickCab/utils/app_colors.dart';
import 'package:flutter/material.dart';

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
          hintStyle: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.subTitleColor),
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your fare amount';
          } else if (int.parse(value) <= 0) {
            return 'Fare amount should be greater than 0';
          }
          return null;
        },
      )
    ],
  );
}
