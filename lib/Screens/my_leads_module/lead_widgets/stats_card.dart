import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsCard extends StatelessWidget {
  final int activeLeads;
  final int completed;
  final double totalValue;

  const StatsCard({
    super.key,
    required this.activeLeads,
    required this.completed,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50, // light red background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            value: activeLeads.toString(),
            label: "active_leads".tr,
            color: ColorsForApp.red,
          ),
          _buildStat(
            value: completed.toString(),
            label: "completed".tr,
            color: ColorsForApp.green,
          ),
          _buildStat(
            value: "₹ ${totalValue.toInt()}",
            label: "total_value".tr,
            color: ColorsForApp.primaryDarkColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required String value, required String label, required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextHelper.size20.copyWith(color: color, fontFamily: boldFont)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
        ),
      ],
    );
  }
}
