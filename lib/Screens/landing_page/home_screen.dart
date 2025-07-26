import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constant_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Main Page",
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.black,
          size: 22.sp,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }
}
