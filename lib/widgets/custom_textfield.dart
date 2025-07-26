import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../utils/text_styles.dart';
import 'constant_widgets.dart';

class CustomTextField extends StatelessWidget {
  final void Function()? onTap;
  final InputDecoration? decoration;
  final bool autofocus;
  final bool readOnly;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool prefixIconWidthFlexible;
  final bool enabled;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? counterText;
  final InputBorder? border;
  final int? maxLines;
  final TextStyle? errorStyle;
  final void Function(String)? onChanged;
  final bool isMandatory;
  const CustomTextField({
    super.key,
    this.onTap,
    this.decoration,
    this.autofocus = false,
    this.readOnly = false,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.controller,
    this.prefixIconWidthFlexible = false,
    this.enabled = true,
    this.suffixIcon,
    this.validator,
    this.style,
    this.inputFormatters,
    this.maxLength,
    this.keyboardType,
    this.counterText,
    this.border,
    this.maxLines,
    this.errorStyle,
    this.onChanged,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onTap: onTap,
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      style: TextHelper.size16(context).merge(style),
      cursorWidth: 1,
      maxLength: maxLength,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      cursorHeight: 2.h,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: decoration ??
          InputDecoration(
            labelText: labelText,
            counterText: counterText ?? '',
            contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: prefixIcon == null ? 2.w : 0),
            labelStyle: TextHelper.size16(context).merge(labelStyle),
            hintText: isMandatory ? '$hintText *' : hintText,
            hintStyle: TextHelper.size14(context).copyWith(color: Colors.grey.withOpacity(0.75)).merge(hintStyle),
            errorStyle: TextStyle(fontSize: 13.sp).merge(errorStyle),
            prefixIcon: prefixIcon == null
                ? null
                : (prefixIconWidthFlexible
                    ? IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (prefixIcon != null) prefixIcon!,
                            VerticalDivider(
                              indent: 1.h,
                              endIndent: 1.h,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: 15.w,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (prefixIcon != null) Expanded(child: Center(child: prefixIcon!)),
                              VerticalDivider(
                                indent: 1.h,
                                endIndent: 1.h,
                                width: 0,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                              width(2.w),
                            ],
                          ),
                        ),
                      )),
            suffixIcon: suffixIcon,
            border: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
            enabledBorder: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
            disabledBorder: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
                  ),
                ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedBorder: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.25,
              ),
            ),
          ),
    );
  }
}


class CustomSearchLocationTextField extends StatelessWidget {
  final void Function()? onTap;
  final bool? readOnly;
  final String? label;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  const CustomSearchLocationTextField({super.key, this.onTap, this.readOnly, this.label, this.prefixIcon, this.controller});
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onTap: onTap,
      autofocus: true,
      hintText: 'Search',
      labelText: label,
      prefixIcon: prefixIcon ??
          Icon(
            CupertinoIcons.location,
            size: 18.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
      readOnly: readOnly ?? false,
    );
  }
}
