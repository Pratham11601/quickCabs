import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/text_style.dart';

class CommonTextfiled extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final void Function()? onTap;
  final InputDecoration? decoration;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final TextStyle? style;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? counterText;
  final InputBorder? border;
  final int? maxLines;
  final TextStyle? errorStyle;
  final void Function(String)? onChanged;

  const CommonTextfiled({
    super.key,
    this.height,
    this.width,
    this.color,
    this.onTap,
    this.decoration,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.style,
    this.maxLength,
    this.keyboardType,
    this.counterText,
    this.border,
    this.maxLines,
    this.errorStyle,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText ?? "Data",
        hintStyle: TextHelper.size16(context).copyWith(color: ColorsForApp.colorBlackShade, fontWeight: FontWeight.w400),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      style: TextHelper.size16(context).copyWith(color: ColorsForApp.colorBlackShade, fontWeight: FontWeight.w400),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
