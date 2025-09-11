import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../model/mylead_model.dart';

class CompletedLeadCard extends StatelessWidget {
  final Lead lead;

  const CompletedLeadCard({
    Key? key,
    required this.lead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route & Fare Row (Top Row)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.navigation_outlined, color: ColorsForApp.green, size: 20),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          lead.locationFrom ?? '',
                          style: TextHelper.size18.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_right_alt, color: Colors.black, size: 20),
                      SizedBox(width: 8),
                      Icon(Icons.location_on, color: ColorsForApp.red, size: 20),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          lead.toLocation ?? '',
                          style: TextHelper.size18.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: semiBoldFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "₹${lead.fare?.toString() ?? ''}",
                  style: TextHelper.size19.copyWith(
                    color: ColorsForApp.green,
                    fontFamily: semiBoldFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(width: 2),
                // Theme(
                //   data: Theme.of(context).copyWith(
                //     visualDensity: VisualDensity.compact,
                //     iconButtonTheme: IconButtonThemeData(
                //       style: ButtonStyle(
                //         padding: MaterialStateProperty.all(EdgeInsets.zero),
                //         minimumSize: MaterialStateProperty.all(const Size(24, 24)),
                //         fixedSize: MaterialStateProperty.all(const Size(24, 24)),
                //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //       ),
                //     ),
                //   ),
                //   child: PopupMenuButton<String>(
                //     padding: EdgeInsets.zero,
                //     iconSize: 20,
                //     icon: const Icon(Icons.more_vert, color: Colors.black),
                //     color: ColorsForApp.whiteColor,
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //     itemBuilder: (context) => [
                //       // PopupMenuItem(
                //       //   value: 'share',
                //       //   child: Row(children: [
                //       //     Icon(Icons.share, size: 18), SizedBox(width: 8),
                //       //     Text("Share Lead", style: TextHelper.size17.copyWith(
                //       //         color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                //       //   ]),
                //       // ),
                //       PopupMenuItem(
                //         value: 'edit',
                //         child: Row(children: [
                //           Icon(Icons.edit, size: 18),
                //           SizedBox(width: 8),
                //           Text("Edit Lead", style: TextHelper.size17.copyWith(color: ColorsForApp.blackColor, fontFamily: semiBoldFont)),
                //         ]),
                //       ),
                //       // PopupMenuItem(
                //       //   value: 'delete',
                //       //   child: Row(children: [
                //       //     Icon(Icons.delete, size: 18, color: Colors.red),
                //       //     SizedBox(width: 8),
                //       //     Text("Delete Lead", style: TextHelper.size17.copyWith(color: ColorsForApp.red, fontFamily: semiBoldFont)),
                //       //   ]),
                //       // ),
                //     ],
                //     onSelected: (v) {
                //       if (v == 'share') onShare();
                //       if (v == 'edit') onEdit();
                //       if (v == 'delete') onDelete();
                //     },
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 8.sp),

            // Second Row: Car Model & Distance
            Row(
              children: [
                Icon(Icons.directions_car, color: ColorsForApp.red, size: 18),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    lead.carModel ?? '',
                    style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.sp),
            // Third Row: Date & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: ColorsForApp.blackColor),
                    SizedBox(width: 6),
                    Text(
                      lead.date != null
                          ? "${lead.date.year.toString().padLeft(4, '0')}-${lead.date.month.toString().padLeft(2, '0')}-${lead.date.day.toString().padLeft(2, '0')}"
                          : '',
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: ColorsForApp.blackColor),
                    SizedBox(width: 6),
                    Text(
                      lead.time ?? '',
                      style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 7.sp),

            // Fourth Row: Phone & PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: ColorsForApp.blackColor),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        lead.vendorContact ?? '',
                        style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "PIN: ${lead.otp ?? ''}",
                    style: TextHelper.size18.copyWith(color: ColorsForApp.primaryDarkColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
