import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';

class LeadCard extends StatelessWidget {
  final Map<String, dynamic> lead;
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LeadCard({
    Key? key,
    required this.lead,
    required this.onShare,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Row

            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.navigation_outlined, color: ColorsForApp.green),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lead['from'],
                          style: TextHelper.size18.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right_alt, color: Colors.black),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lead['to'],
                          style: TextHelper.size18.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text("₹${lead['price']}", style: TextHelper.size20.copyWith(color: ColorsForApp.green, fontFamily: semiBoldFont)),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  color: ColorsForApp.whiteColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onSelected: (value) {
                    if (value == 'share') onShare();
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "share",
                      child: Row(
                        children: [
                          Icon(Icons.share, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Share Lead",
                            style: TextHelper.size17.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text("Edit Lead", style: TextHelper.size17.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete Lead", style: TextHelper.size17.copyWith(color: ColorsForApp.red, fontFamily: semiBoldFont)),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 6),

            // Car details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_car_outlined, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      lead['carType'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      lead['distance'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Date & Time row

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['date'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['time'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Phone + PIN

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: ColorsForApp.blackColor),
                    const SizedBox(width: 6),
                    Text(
                      lead['phone'],
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("PIN: ${lead['pin']}", style: TextHelper.size18.copyWith(color: ColorsForApp.primaryDarkColor)),
                )
              ],
            ),

            const Divider(height: 16),
            Text(
              "\"${lead['note']}\"",
              style: TextHelper.size18.copyWith(
                fontStyle: FontStyle.italic,
                fontFamily: semiBoldFont,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
