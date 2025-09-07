import 'package:flutter/material.dart';
import 'package:QuickCab/utils/app_colors.dart';

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
  bool isNumeric = false, // 👈 optional named parameter
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextHelper.size18.copyWith(fontFamily: semiBoldFont)),
      const SizedBox(height: 6),
      TextField(
        keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        controller: controller,
        style: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextHelper.size19.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.subTitleColor),
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12, // keeps it comfortable, not too tall/short
          ),
        ),
      )
    ],
  );
}
