import 'package:flutter/material.dart';

import '../utils/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text("text", style: TextHelper.size14)],
      ),
    );
  }
}
