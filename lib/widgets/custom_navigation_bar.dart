import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final RxInt currentIndex;
  final List<BottomNavigationBarItem> items;
  final void Function(int index)? onChange;
  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsForApp.primaryColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            blurRadius: 2,
            spreadRadius: 3,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Obx(
        () => BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: currentIndex.value,
          onTap: (int index) {
            if (onChange != null) {
              onChange!(index);
            }
            currentIndex.value = index;
          },
          items: items,
        ),
      ),
    );
  }
}
