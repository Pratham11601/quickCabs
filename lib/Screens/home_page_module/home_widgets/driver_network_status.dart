import 'package:flutter/material.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:own_idea/utils/text_styles.dart';

/// A reusable widget that shows Driver Network Status.
/// You can customize [onlineDrivers], [statusText], [isHighDemand],
/// and other properties for reuse in different places.
class DriverNetworkStatusCard extends StatelessWidget {
  final int onlineDrivers;
  final bool isActive;
  final bool isHighDemand;

  const DriverNetworkStatusCard({
    super.key,
    required this.onlineDrivers,
    this.isActive = true,
    this.isHighDemand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsForApp.colorBlue.withValues(alpha: 0.1), // Light background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorsForApp.colorBlue.withValues(alpha: 0.2), // Border color
          width: 2, // Border thickness
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorsForApp.colorBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.people_alt_outlined,
              color: ColorsForApp.colorBlue.withValues(alpha: 0.8),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          // Texts & status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title Row with "Active" badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Driver Network Status",
                        style: TextHelper.size20.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),

                    /// Active / Inactive badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.red : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(isActive ? "Active" : "Inactive",
                          style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: semiBoldFont)),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// Online driver count with green dot
                Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.green),
                    const SizedBox(width: 4),
                    Text("$onlineDrivers drivers online",
                        style: TextHelper.size18.copyWith(color: ColorsForApp.green, fontFamily: regularFont)),
                    const SizedBox(width: 4),
                    Text("in your area", style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont)),
                  ],
                ),

                const SizedBox(height: 6),

                /// High demand zone indicator
                if (isHighDemand)
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.grey),
                      SizedBox(width: 6),
                      Text("High demand zone", style: TextHelper.size18.copyWith(color: ColorsForApp.orange, fontFamily: semiBoldFont)),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
