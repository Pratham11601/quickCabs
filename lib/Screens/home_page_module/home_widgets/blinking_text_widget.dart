import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color color;
  final Duration duration;
  final double minOpacity;

  const BlinkingText(
    this.text, {
    super.key,
    this.style,
    this.color = Colors.red, // default color
    this.duration = const Duration(seconds: 1),
    this.minOpacity = 0.2,
  });

  @override
  State<BlinkingText> createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 1.0, end: widget.minOpacity).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        widget.text,
        style: widget.style?.copyWith(color: widget.color) ?? TextStyle(color: widget.color),
      ),
    );
  }
}
