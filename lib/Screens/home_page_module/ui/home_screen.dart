import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/constant_widgets.dart';
import '../../landing_page/controller/dashboard_controller.dart';
import '../controller/home_controller.dart';
import '../home_widgets/driver_network_status.dart';
import '../home_widgets/emergency_service_item.dart';
import '../home_widgets/lead_card.dart';
import '../home_widgets/ride_request_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardController dashboardController = Get.find();
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    callAsyncAPI();
    super.initState();
  }

  Future<void> callAsyncAPI() async {
    bool result = await homeController.checkProfileCompletion();
    if (result) {
      if (!homeController.isKycCompleted.value) {
        showCommonMessageDialog(
          Get.context!,
          'Profile Incomplete',
          'Your profile is not completed please complete you profile',
          () {
            Get.toNamed(Routes.MY_DOCUMENTS);
          },
        );
      }
    }
    //🔴🔴here is the reason if error occurs🔴🔴
    //await homeController.fetchLeads();
    await homeController.fetchLiveLeads();
    await homeController.fetchActiveLeads();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, top: 25, right: 15, bottom: 15),
      child: RefreshIndicator(
        onRefresh: () async {
          callAsyncAPI();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //booking and available
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7, // 60% of screen width
                padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTab(
                        title: "Booking",
                        index: 0,
                        controller: homeController,
                      ),
                      SizedBox(width: 8.w),
                      _buildTab(
                        title: "Available",
                        index: 1,
                        controller: homeController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.5.sp),
            Obx(() {
              // if booking is selectd →original content
              // if available is selected → card content
              if (homeController.selectedIndex.value == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emergency services
                    EmergencyServicesSection(),
                    const SizedBox(height: 20),
                    // Leads

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shared Leads",
                          style: TextHelper.h6.copyWith(
                            fontFamily: semiBoldFont,
                            color: ColorsForApp.blackColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            dashboardController.currentIndex.value = 1;
                          },
                          child: Text(
                            "View All",
                            style: TextHelper.size19.copyWith(
                              fontFamily: semiBoldFont,
                              color: ColorsForApp.primaryDarkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() => ListView.builder(
                          shrinkWrap: true, // If you're inside a scrollable parent
                          physics: NeverScrollableScrollPhysics(), // Prevent double scrolling
                          itemCount: homeController.activeLeads.length,
                          itemBuilder: (_, index) {
                            final lead = homeController.activeLeads[index];
                            return LeadCard(
                              lead: {
                                'name': lead.vendorFullname,
                                'from': lead.locationFrom,
                                'to': lead.toLocation,
                                'price': lead.fare,
                                'car': lead.carModel,
                                'distance': lead.toLocationArea,
                                'date': lead.date,
                                'time': lead.time,
                                'phone': lead.vendorContact,
                                'note': lead.addOn,
                                'acceptedById': lead.acceptedById,
                              },
                              onAccept: () => homeController.acceptLead(index),
                            );
                          },
                        )),

                    const SizedBox(height: 12),

                    Center(
                      child: DriverNetworkStatusCard(
                        onlineDrivers: 156,
                        isActive: true,
                        isHighDemand: true,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Driver Status Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.2.h),
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xffD9F1E4), width: 0.4.w),
                        borderRadius: BorderRadius.circular(3.w),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            color: Color(0x14000000),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left Icon Circle
                          Container(
                            height: 6.5.h,
                            width: 6.5.h,
                            decoration: BoxDecoration(
                              color: ColorsForApp.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.smartphone, color: Colors.white, size: 3.2.h),
                          ),
                          SizedBox(width: 3.5.w),

                          // Text Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Driver Status',
                                  style: TextHelper.size20.copyWith(
                                    fontFamily: boldFont,
                                    color: ColorsForApp.blackColor,
                                  ),
                                ),
                                SizedBox(height: 0.4.h),
                                Text(
                                  'You are online and accepting rides',
                                  style: TextHelper.size17.copyWith(
                                    fontFamily: regularFont,
                                    color: ColorsForApp.subTitleColor,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right Action Button
                          SizedBox(
                            height: 5.h,
                            child: ElevatedButton(
                              onPressed: () {
                                // Toggle online/offline
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFF6A3D),
                                foregroundColor: Colors.white,
                                elevation: 1,
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.5.w),
                                ),
                              ),
                              child: Text(
                                'Go Offline',
                                style: TextHelper.size18.copyWith(
                                  fontFamily: boldFont,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Live Ride Requests
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.2.h),
                      child: Row(
                        children: [
                          Container(
                            height: 5.2.h,
                            width: 5.2.h,
                            decoration: BoxDecoration(
                              color: ColorsForApp.primaryDarkColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2.5.w),
                            ),
                            child: Icon(Icons.monitor_heart, color: ColorsForApp.primaryColor, size: 2.6.h),
                          ),
                          SizedBox(width: 3.w),

                          Expanded(
                            child: Text(
                              'Live Ride Requests',
                              style: TextHelper.size20.copyWith(
                                fontFamily: semiBoldFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ),

                          // "New" pill
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.6.h),
                            decoration: BoxDecoration(
                              color: ColorsForApp.primaryDarkColor,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                  color: Color(0x14000000),
                                ),
                              ],
                            ),
                            child: Text(
                              'New',
                              style: TextHelper.size18.copyWith(
                                fontFamily: boldFont,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ride Request Cards
                    Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: homeController.liveLeads.length,
                        separatorBuilder: (_, __) => SizedBox(height: 1.2.h),
                        itemBuilder: (_, i) => RideRequestCard(
                          lead: homeController.liveLeads[i],
                          onDecline: () => homeController.declineLiveLead(i),
                          onAccept: () => homeController.acceptLiveLead(i),
                        ),
                      );
                    }),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

// Reusable tab widget
Widget _buildTab({
  required String title,
  required int index,
  required HomeController controller,
}) {
  final isSelected = controller.selectedIndex.value == index;
  return GestureDetector(
    onTap: () => controller.selectedIndex.value = index,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Text(title, style: TextHelper.size18.copyWith(fontFamily: semiBoldFont, color: ColorsForApp.blackColor)),
    ),
  );
}
