import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:own_idea/routes/routes.dart';
import 'package:own_idea/widgets/constant_widgets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, top: 25, right: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //booking and available
          Center(
            child: Container(
              width: 88.w,
              padding: EdgeInsets.symmetric(
                  horizontal: 2.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          homeController.selectedIndex.value = 0;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 1.2.h),
                          decoration: BoxDecoration(
                            color: homeController.selectedIndex.value == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: homeController.selectedIndex.value == 0
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            "Booking",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          homeController.selectedIndex.value = 1;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 1.2.h), // smaller vertical
                          decoration: BoxDecoration(
                            color: homeController.selectedIndex.value == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: homeController.selectedIndex.value == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            "Available",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
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

                  Obx(() => Column(
                    children: homeController.leads
                        .map((lead) => LeadCard(lead: lead))
                        .toList(),
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
                children: [
                  //this is driver status container
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color(0xffD9F1E4), width: 0.5.w),
                      borderRadius: BorderRadius.circular(4.w),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 0.3),
                          blurRadius: 10,
                          color: Color(0x14000000),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 7.h,
                          width: 7.h,
                          decoration: BoxDecoration(
                            color: Color(0xff1BB56E),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.smartphone,
                              color: Colors.white, size: 3.5.h),
                        ),
                        SizedBox(width: 4.w),

                        // Title + subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Driver Status',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1C1C1E),
                                ),
                              ),
                              SizedBox(height: 0.8.h),
                              Text(
                                'You are online and\naccepting rides',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 1.3,
                                  color: Color(0xff666A6D),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right action button
                        SizedBox(
                          height: 5.5.h,
                          child: ElevatedButton(
                            onPressed: () {
                              // handle go offline / online
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffFF6A3D),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 1.5.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                              ),
                            ),
                            child: Text(
                              'Go Offline',
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //live ride Requests
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    child: Row(
                      children: [
                        Container(
                          height: 5.5.h,
                          width: 5.5.h,
                          decoration: BoxDecoration(
                            color: Color(0xffFFE8DF),
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Icon(Icons.monitor_heart,
                              color: Color(0xffFF6A3D), size: 3.h),
                        ),
                        SizedBox(width: 3.w),

                        Expanded(
                          child: Text(
                            'Live Ride Requests',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff1C1C1E),
                            ),
                          ),
                        ),

                        // "New" pill
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: Color(0xffFF6A3D),
                            borderRadius: BorderRadius.circular(6.w),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                offset: Offset(0, 0.3),
                                color: Color(0x14000000),
                              )
                            ],
                          ),
                          child: Text(
                            'New',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///cards

                  // Obx(() {
                  //   return ListView.separated(
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: homeController.leads.length,
                  //     separatorBuilder: (_, __) => SizedBox(height: 8),
                  //     itemBuilder: (_, i) => RideRequestCard(
                  //       lead: homeController.leads[i],
                  //       onDecline: () => homeController.declineLead(i),
                  //       onAccept:  () => homeController.acceptLead(i),
                  //     ),
                  //   );
                  // })
                  Obx(() {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: homeController.liveLeads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => RideRequestCard(
                        lead: homeController.liveLeads[i],
                        onDecline: () => homeController.declineLiveLead(i),
                        onAccept:  () => homeController.acceptLiveLead(i),
                      ),
                    );
                  }),

                ],
              );
            }
          }),
        ],
      ),
    );
  }
}
