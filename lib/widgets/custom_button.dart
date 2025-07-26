import 'package:flutter/material.dart';

import '../utils/text_styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? labelStyle;
  final EdgeInsets? padding;
  final double? width;
  final BorderRadius? borderRadius;

  final Color? buttonColor;

  final BorderSide borderSide;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.labelStyle,
    this.padding,
    this.width,
    this.borderRadius,
    this.buttonColor,
    this.borderSide = BorderSide.none,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      color: buttonColor ?? (borderSide != BorderSide.none ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary),
      padding: padding,
      shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(22), side: borderSide),
      splashColor: Colors.transparent,
      child: Text(
        label,
        style: TextHelper.size18(context)
            .copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface)
            .merge(labelStyle),
      ),
    );
  }
}
