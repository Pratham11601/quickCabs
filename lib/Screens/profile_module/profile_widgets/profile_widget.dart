import 'package:QuickCab/Screens/profile_module/controller/profile_controller.dart';
import 'package:QuickCab/notificaton/notifications_services.dart';
import 'package:QuickCab/utils/app_colors.dart';
import 'package:QuickCab/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Profile Info Card

class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String profileImage;

  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          /// Circle Avatar with initials
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.orange.shade100,
            backgroundImage:
                (profileImage.isNotEmpty) ? NetworkImage(profileImage) : null,
            child: (profileImage.isEmpty)
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                    style: TextHelper.h4.copyWith(
                        color: ColorsForApp.red, fontFamily: semiBoldFont),
                  )
                : null,
          ),

          const SizedBox(width: 16),

          /// User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextHelper.h6.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: semiBoldFont)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone_outlined,
                        size: 18, color: ColorsForApp.subtitle),
                    const SizedBox(width: 6),
                    Text(phone,
                        style: TextHelper.size17.copyWith(
                            color: ColorsForApp.subtitle,
                            fontFamily: semiBoldFont)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email_outlined,
                        size: 18, color: ColorsForApp.subtitle),
                    const SizedBox(width: 6),
                    Text(email,
                        style: TextHelper.size17.copyWith(
                            color: ColorsForApp.subtitle,
                            fontFamily: semiBoldFont)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// ---------- Setting Item MODEL ----------
class SettingItem {
  final IconData icon;
  final String title;
  final String? label;
  final bool hasSwitch;
  bool switchValue;
  final bool isLanguage;
  final VoidCallback? onTap;
  final RxBool? toggleValue;
  final Widget? trailing;
  final Future<void> Function(bool)? onToggle; // ✅ NEW CALLBACK

  SettingItem({
    required this.icon,
    required this.title,
    this.label,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onTap,
    this.toggleValue,
    this.trailing,
    this.onToggle,
    this.isLanguage = false,
  });
}

/// Setting Card Widget
class SettingsCard extends StatelessWidget {
  final String sectionTitle;
  final List<SettingItem> items;

  // Use Get.find() here (don't create controller every rebuild)
  final ProfileController controller = Get.find<ProfileController>();

  SettingsCard({
    super.key,
    required this.sectionTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section Title
            Text(
              sectionTitle,
              style: TextHelper.size20.copyWith(
                color: ColorsForApp.blackColor,
                fontFamily: semiBoldFont,
              ),
            ),
            const SizedBox(height: 12),

            /// Items List
            Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                return Column(
                  children: [
                    InkWell(
                      splashColor:
                          ColorsForApp.subTitleColor.withValues(alpha: 0.1),
                      onTap: item.hasSwitch ? null : item.onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Icon(item.icon,
                                size: 23, color: ColorsForApp.primaryDarkColor),
                            const SizedBox(width: 16),

                            /// Title
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextHelper.size19.copyWith(
                                  color: ColorsForApp.blackColor,
                                  fontFamily: semiBoldFont,
                                ),
                              ),
                            ),

                            /// Label (optional)
                            if (item.label != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4D6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.label!,
                                  style: TextHelper.size18.copyWith(
                                    color: ColorsForApp.blackColor,
                                    fontFamily: semiBoldFont,
                                  ),
                                ),
                              ),

                            /// Trailing Widget or Switch
                            if (item.hasSwitch)
                              item.toggleValue != null
                                  ? Obx(() => Switch(
                                        value: item.toggleValue!.value,
                                        onChanged: (val) async {
                                          print("Switch ${item.title} to $val");
                                          item.toggleValue!.value = val;
                                          if (item.onToggle != null) {
                                            await item.onToggle!(val);
                                          }
                                        },
                                        activeColor: Colors.white,
                                        activeTrackColor: Colors.redAccent,
                                      ))
                                  : StatefulBuilder(
                                      builder: (context, setState) => Switch(
                                        value: item.switchValue,
                                        onChanged: (val) async {
                                          setState(() {
                                            item.switchValue = val;
                                          });
                                          if (item.onToggle != null) {
                                            await item.onToggle!(val);
                                          }
                                          print("Switch ${item.title} to $val");
                                        },
                                        activeColor: Colors.white,
                                        activeTrackColor: Colors.redAccent,
                                      ),
                                    )
                            else if (item.isLanguage)
                              Obx(
                                () => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.selectedLanguage.value,
                                      style: TextHelper.size18.copyWith(
                                        color: ColorsForApp.blackColor,
                                        fontFamily: semiBoldFont,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.chevron_right,
                                        color: Colors.black45),
                                  ],
                                ),
                              )
                            else
                              item.trailing ??
                                  const Icon(Icons.chevron_right,
                                      color: Colors.black45),
                          ],
                        ),
                      ),
                    ),

                    /// Divider except last item
                    if (index != items.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 0.6,
                        color: Colors.black12,
                      ),
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

/// Logout Button
class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;
  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, size: 30, color: ColorsForApp.red),
        title: Text(
          "Logout",
          style: TextHelper.h6
              .copyWith(color: ColorsForApp.red, fontFamily: semiBoldFont),
        ),
        onTap: onLogout,
      ),
    );
  }
}
