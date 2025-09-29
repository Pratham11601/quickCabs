import 'package:QuickCab/Screens/profile_module/controller/profile_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/config.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/no_data_found.dart';
import '../../../widgets/shimmer_widget.dart';
import '../../../widgets/snackbar.dart';
import '../../landing_page/controller/dashboard_controller.dart';
import '../controller/home_controller.dart';
import '../home_widgets/blinking_text_widget.dart';
import '../home_widgets/emergency_service_item.dart';
import '../home_widgets/lead_card.dart';
import '../home_widgets/ride_request_card.dart';
import '../model/active_lead_model.dart';
import '../model/all_live_lead_model.dart';
import '../model/live_lead_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardController dashboardController = Get.find();
  final HomeController homeController = Get.find();
  final ProfileController profileController = Get.put(ProfileController());
  final GlobalKey<FormState> filterFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> postAvailablityFormKey = GlobalKey<FormState>();

  late final activeLeadsPagingController = PagingController<int, Post>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (int pageKey) async {
      final response = await homeController.fetchActiveLeads(pageKey);
      final items = response.posts;
      return items;
    },
  );

  late final allDriverPagingController = PagingController<int, AllLiveLeadData>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (int pageKey) async {
      final response = await homeController.fetchAllDriversAvailability(pageKey);
      final items = response.data;
      return items ?? [];
    },
  );

  late final myAvailablityPagingController = PagingController<int, LiveLeadData>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (int pageKey) async {
      final response = await homeController.fetchMyAvailability(pageKey);
      final items = response.data;
      return items ?? [];
    },
  );

  @override
  void initState() {
    callAsyncAPI();
    super.initState();
  }

  Future<void> callAsyncAPI() async {
    try {
      // Profile check
      // await homeController.checkProfileCompletion();
      await profileController.getProfileDetails();
      if (profileController.userDetails.value!.status == 0) {
        showCommonMessageDialog(
          Get.context!,
          'KYC Submitted',
          'Please wait 24 hours, and then contact the administrator if needed...!',
          () {
            Get.toNamed(Routes.HELP_PAGE);
          },
        );
      }
    } catch (e) {
      debugPrint("Error in callAsyncAPI: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        return homeController.selectedIndex.value == 1
            ? GestureDetector(
                onTap: () {
                  showBottomSheetForPostAvailability(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: ColorsForApp.primaryDarkColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                      const SizedBox(height: 3),
                      Text(
                        "POST",
                        style: TextHelper.size18.copyWith(
                          fontFamily: boldFont,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink();
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          await callAsyncAPI();
          activeLeadsPagingController.refresh();
          myAvailablityPagingController.refresh();
          allDriverPagingController.refresh();
        },
        child: PagingListener<int, Post>(
          controller: activeLeadsPagingController,
          builder: (context, state, fetchNextPage) {
            // state & fetchNextPage are required for PagedSliverList
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 14.5.sp)),

                // Tabs
                SliverToBoxAdapter(
                  child: Container(
                    width: 100.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTab(title: "Booking", index: 0, controller: homeController),
                          _buildTab(title: "Available", index: 1, controller: homeController),
                        ],
                      );
                    }),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 14.5.sp)),

                // Conditional Slivers using Obx + MultiSliver
                Obx(() {
                  return MultiSliver(
                    children: homeController.selectedIndex.value == 0 ? _bookingSlivers(state, fetchNextPage) : _availableSlivers(),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

// Booking Slivers
  List<Widget> _bookingSlivers(PagingState<int, Post> state, NextPageCallback fetchNextPage) {
    return [
      // Emergency Services Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: EmergencyServicesSection(),
        ),
      ),
      SliverToBoxAdapter(child: const SizedBox(height: 16)),

      // Banner: shimmer during loading or carousel when loaded
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Obx(() {
            if (homeController.isBannerLoading.value) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 20.h,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            } else {
              if (homeController.banners.isEmpty) {
                return SizedBox.shrink();
              } else {
                return CarouselSlider(
                  options: CarouselOptions(
                    height: 20.h,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                  items: homeController.banners.map((banner) {
                    final imageUrl = "${Config.baseUrl}${banner.image}";

                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Center(
                                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }
            }
          }),
        ),
      ),
      SliverToBoxAdapter(child: const SizedBox(height: 20)),

      // Shared Leads Header + Filter
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
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
                  // Existing filter bottom sheet
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Form(
                        key: filterFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Filter Leads", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: homeController.fromLocationController,
                              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                              decoration: InputDecoration(
                                hintText: "Enter from location",
                                labelText: "From Location",
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(fontSize: 13.sp),
                              ),
                              onChanged: (value) => homeController.fromLocation.value = value,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter From Location' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: homeController.toLocationController,
                              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor, fontFamily: regularFont),
                              decoration: InputDecoration(
                                hintText: "Enter to location",
                                labelText: "To Location",
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(fontSize: 13.sp),
                              ),
                              onChanged: (value) => homeController.toLocation.value = value,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter To Location' : null,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      homeController.clearFilter(); // reset filter state
                                      activeLeadsPagingController.refresh(); // clears + triggers reload
                                      Get.back();
                                    },
                                    child: Text("Clear", style: TextHelper.size18.copyWith(color: Colors.black, fontFamily: boldFont)),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () {
                                      if (filterFormKey.currentState!.validate()) {
                                        homeController.applyFilter();
                                        activeLeadsPagingController.refresh();
                                        Get.back();
                                      }
                                    },
                                    child: Text(
                                      "Apply",
                                      style: TextHelper.size18.copyWith(color: Colors.white, fontFamily: boldFont),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: homeController.isFilterApplied.value ? ColorsForApp.red : ColorsForApp.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_alt_outlined,
                            color: homeController.isFilterApplied.value ? ColorsForApp.whiteColor : ColorsForApp.blackColor, size: 16),
                        SizedBox(width: 4),
                        Text(homeController.isFilterApplied.value ? "Filtered" : 'Filter',
                            style: homeController.isFilterApplied.value
                                ? TextHelper.size18.copyWith(
                                    fontFamily: semiBoldFont,
                                    color: ColorsForApp.whiteColor,
                                  )
                                : TextHelper.size18.copyWith(
                                    fontFamily: semiBoldFont,
                                    color: ColorsForApp.blackColor,
                                  )),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: const SizedBox(height: 12)),
      // Paged List
      PagedSliverList<int, Post>(
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          animateTransitions: true,
          itemBuilder: (context, item, index) {
            final lead = item;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: LeadCard(
                lead: {
                  'name': lead.vendorName,
                  'from': lead.locationFrom,
                  'to': lead.toLocation,
                  'price': lead.fare,
                  'car': lead.carModel,
                  'distance': lead.toLocationArea,
                  'date': lead.date,
                  // homeController.formatDateTime(lead.date!),
                  'time': lead.time,
                  'phone': lead.vendorContact,
                  'note': lead.addOn,
                  'lead_status': lead.leadStatus,
                  'id': lead.id,
                  'trip_type': lead.tripType,
                },
                onAccept: () => homeController.acceptLead(lead),
                onWhatsApp: (phone) => homeController.openWhatsApp(phone),
                onCall: (phone) => homeController.makeCall(phone),
              ),
            );
          },
          firstPageProgressIndicatorBuilder: (_) => leadCardShimmer(),
          newPageProgressIndicatorBuilder: (_) => leadCardShimmer(),
          noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: ""),
        ),
      ),
      SliverToBoxAdapter(child: const SizedBox(height: 8)),
    ];
  }

// Available Slivers
  List<Widget> _availableSlivers() {
    return [
      SliverToBoxAdapter(child: SizedBox(height: 5)),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1.2.h),
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // All Drivers Button
                InkWell(
                  onTap: () => homeController.showMyAvailability.value = false,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: homeController.showMyAvailability.value ? ColorsForApp.subTitleColor : ColorsForApp.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() {
                      final count = homeController.driversCount.value;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            count > 0 ? "All Drivers - " : "All Drivers",
                            style: TextHelper.size18.copyWith(
                              fontFamily: boldFont,
                              color: Colors.white,
                            ),
                          ),
                          if (count > 0)
                            BlinkingText(
                              "$count Online",
                              style: TextHelper.size18.copyWith(
                                fontFamily: boldFont,
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),

                // My Availability Button
                InkWell(
                  onTap: () => homeController.showMyAvailability.value = true,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: homeController.showMyAvailability.value ? ColorsForApp.primaryDarkColor : ColorsForApp.subTitleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'My Availability',
                      style: TextHelper.size18.copyWith(
                        fontFamily: boldFont,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),

      // Conditional Paging Lists
      Obx(() {
        if (homeController.showMyAvailability.value) {
          return PagingListener<int, LiveLeadData>(
            controller: myAvailablityPagingController,
            builder: (context, state, fetchNextPage) {
              return PagedSliverList<int, LiveLeadData>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<LiveLeadData>(
                  itemBuilder: (context, item, index) {
                    final lead = item;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: RideRequestCard(
                        lead: {
                          'name': lead.name,
                          'car': lead.car,
                          'location': lead.location,
                          'from_date': homeController.formatDateTime(lead.fromDate!),
                          'from_time': homeController.formatTime(lead.fromTime!),
                          'to_date': homeController.formatDateTime(lead.toDate!),
                          'to_time': homeController.formatTime(lead.toTime!),
                          'phone': lead.phone,
                          'status': lead.status,
                        },
                        showToggle: true,

                        onWhatsApp: (phone) =>
                            // dashboardController.isSubscribed.value?
                            homeController.openWhatsApp(phone),
                        // : showSubscriptionAlertDialog(
                        //     Get.context!,
                        //     'Subscription Required',
                        //     'Your subscription is not active. Please subscribe to post a lead.',
                        //     () => Get.toNamed(Routes.SUBSCRIPTION),
                        //   ),
                        onCall: (phone) =>
                            //  dashboardController.isSubscribed.value ?
                            homeController.makeCall(phone),
                        // : showSubscriptionAlertDialog(
                        //     Get.context!,
                        //     'Subscription Required',
                        //     'Your subscription is not active. Please subscribe to post a lead.',
                        //     () => Get.toNamed(Routes.SUBSCRIPTION),
                        //   ),
                        onToggle: (newStatus) async {
                          if (newStatus == 0) {
                            myAvailablityPagingController.refresh();
                          }
                          await homeController.updatetDriverAvailability(
                            status: newStatus,
                            leadId: lead.id!,
                            car: lead.car ?? "",
                            location: lead.location ?? "",
                            fromDate: DateTime.parse(lead.fromDate!),
                            fromTime: homeController.parseTimeOfDay(lead.fromTime!),
                            toDate: DateTime.parse(lead.toDate!),
                            toTime: homeController.parseTimeOfDay(lead.toTime!),
                          );
                        },
                      ),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => leadCardShimmer(),
                  newPageProgressIndicatorBuilder: (_) => leadCardShimmer(),
                  noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: ""),
                ),
              );
            },
          );
        } else {
          return PagingListener<int, AllLiveLeadData>(
            controller: allDriverPagingController,
            builder: (context, state, fetchNextPage) {
              return PagedSliverList<int, AllLiveLeadData>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<AllLiveLeadData>(
                  itemBuilder: (context, item, index) {
                    final lead = item;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: RideRequestCard(
                        lead: {
                          'name': lead.name,
                          'car': lead.car,
                          'location': lead.location,
                          'from_date': homeController.formatDateTime(lead.fromDate!),
                          'from_time': homeController.formatTime(lead.fromTime!),
                          'to_date': homeController.formatDateTime(lead.toDate!),
                          'to_time': homeController.formatTime(lead.toTime!),
                          'phone': lead.phone,
                          'status': lead.status,
                        },
                        showToggle: false,
                        onWhatsApp: (phone) =>
                            // dashboardController.isSubscribed.value
                            //     ?
                            homeController.openWhatsApp(phone),
                        // : showSubscriptionAlertDialog(
                        //     Get.context!,
                        //     'Subscription Required',
                        //     'Your subscription is not active. Please subscribe to post a lead.',
                        //     () => Get.toNamed(Routes.SUBSCRIPTION),
                        //   ),
                        onCall: (phone) =>
                            // dashboardController.isSubscribed.value ?
                            homeController.makeCall(phone),

                        // : showSubscriptionAlertDialog(
                        //     Get.context!,
                        //     'Subscription Required',
                        //     'Your subscription is not active. Please subscribe to post a lead.',
                        //     () => Get.toNamed(Routes.SUBSCRIPTION),
                        //   ),
                        onToggle: (_) {},
                      ),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => leadCardShimmer(),
                  newPageProgressIndicatorBuilder: (_) => leadCardShimmer(),
                  noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: ""),
                ),
              );
            },
          );
        }
      }),
    ];
  }

  // List<Widget> _availableSlivers() {
  //   return [
  //     SliverToBoxAdapter(child: SizedBox(height: 5)),
  //     SliverToBoxAdapter(
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.2.h),
  //         child: Obx(() {
  //           return Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               // All Drivers Button
  //               InkWell(
  //                 borderRadius: BorderRadius.circular(10),
  //                 onTap: () {
  //                   homeController.showMyAvailability.value = false;
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: 4.5.w, vertical: 0.8.h),
  //                   decoration: BoxDecoration(
  //                     color: homeController.showMyAvailability.value
  //                         ? ColorsForApp.subTitleColor
  //                         : ColorsForApp.green,
  //                     borderRadius: BorderRadius.circular(10),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         blurRadius: 4,
  //                         offset: Offset(0, 2),
  //                         color: Color(0x14000000),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Obx(() {
  //                     final count = homeController.driversCount.value;
  //                     return Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Text(
  //                           count > 0 ? "All Drivers - " : "All Drivers",
  //                           style: TextHelper.size18.copyWith(
  //                             fontFamily: boldFont,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                         if (count > 0) ...[
  //                           const SizedBox(width: 6),
  //                           BlinkingText(
  //                             "$count Online",
  //                             style: TextHelper.size18
  //                                 .copyWith(fontFamily: boldFont),
  //                             color: Colors.yellowAccent,
  //                             duration: const Duration(milliseconds: 800),
  //                           ),
  //                         ],
  //                       ],
  //                     );
  //                   }),
  //                 ),
  //               ),

  //               // My Availability Button
  //               InkWell(
  //                 borderRadius: BorderRadius.circular(10),
  //                 onTap: () {
  //                   homeController.showMyAvailability.value = true;
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: 4.5.w, vertical: 0.8.h),
  //                   decoration: BoxDecoration(
  //                     color: homeController.showMyAvailability.value
  //                         ? ColorsForApp.primaryDarkColor
  //                         : ColorsForApp.subTitleColor,
  //                     borderRadius: BorderRadius.circular(10),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         blurRadius: 4,
  //                         offset: Offset(0, 2),
  //                         color: Color(0x14000000),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Text(
  //                     'My Availability',
  //                     style: TextHelper.size18.copyWith(
  //                       fontFamily: boldFont,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         }),
  //       ),
  //     ),
  //     Obx(() {
  //       if (homeController.showMyAvailability.value) {
  //         // My Availability (LiveLeadData) Pagination
  //         return PagingListener<int, LiveLeadData>(
  //           controller: myAvailablityPagingController,
  //           builder: (context, state, fetchNextPage) {
  //             return PagedSliverList<int, LiveLeadData>(
  //               state: state,
  //               fetchNextPage: fetchNextPage,
  //               builderDelegate: PagedChildBuilderDelegate<LiveLeadData>(
  //                 itemBuilder: (context, item, index) {
  //                   final lead = item;
  //                   return RideRequestCard(
  //                     lead: {
  //                       'name': lead.name,
  //                       'car': lead.car,
  //                       'location': lead.location,
  //                       'from_date': lead.fromDate,
  //                       'from_time': lead.fromTime,
  //                       'to_date': lead.toDate,
  //                       'to_time': lead.toTime,
  //                       'phone': lead.phone,
  //                       'status': lead.status,
  //                     },
  //                     showToggle: true,
  //                     onWhatsApp: (phone) =>
  //                         dashboardController.isSubscribed.value
  //                             ? homeController.openWhatsApp(phone)
  //                             : showSubscriptionAlertDialog(
  //                                 Get.context!,
  //                                 'Subscription Required',
  //                                 'Your subscription is not active. Please subscribe to post a lead.',
  //                                 () => Get.toNamed(Routes.SUBSCRIPTION),
  //                               ),
  //                     onCall: (phone) => dashboardController.isSubscribed.value
  //                         ? homeController.makeCall(phone)
  //                         : showSubscriptionAlertDialog(
  //                             Get.context!,
  //                             'Subscription Required',
  //                             'Your subscription is not active. Please subscribe to post a lead.',
  //                             () => Get.toNamed(Routes.SUBSCRIPTION),
  //                           ),
  //                     onToggle: (newStatus) async {
  //                       if (newStatus == 0) {
  //                         myAvailablityPagingController.refresh();
  //                       }
  //                       await homeController.updatetDriverAvailability(
  //                         status: newStatus,
  //                         leadId: lead.id!,
  //                         car: lead.car ?? "",
  //                         location: lead.location ?? "",
  //                         fromDate: DateTime.parse(lead.fromDate!),
  //                         fromTime:
  //                             homeController.parseTimeOfDay(lead.fromTime!),
  //                         toDate: DateTime.parse(lead.toDate!),
  //                         toTime: homeController.parseTimeOfDay(lead.toTime!),
  //                       );
  //                     },
  //                   );
  //                 },
  //                 firstPageProgressIndicatorBuilder: (context) =>
  //                     ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: 1,
  //                   itemBuilder: (_, __) => leadCardShimmer(),
  //                 ),
  //                 newPageProgressIndicatorBuilder: (context) =>
  //                     ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: 1,
  //                   itemBuilder: (_, __) => leadCardShimmer(),
  //                 ),
  //                 noItemsFoundIndicatorBuilder: (context) =>
  //                     NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: ""),
  //               ),
  //             );
  //           },
  //         );
  //       } else {
  //         // All Drivers (AllLiveLeadData) Pagination
  //         return PagingListener<int, AllLiveLeadData>(
  //           controller: allDriverPagingController,
  //           builder: (context, state, fetchNextPage) {
  //             return PagedSliverList<int, AllLiveLeadData>(
  //               state: state,
  //               fetchNextPage: fetchNextPage,
  //               builderDelegate: PagedChildBuilderDelegate<AllLiveLeadData>(
  //                 itemBuilder: (context, item, index) {
  //                   final lead = item;
  //                   return RideRequestCard(
  //                     lead: {
  //                       'name': lead.name,
  //                       'car': lead.car,
  //                       'location': lead.location,
  //                       'from_date': lead.fromDate,
  //                       'from_time': lead.fromTime,
  //                       'to_date': lead.toDate,
  //                       'to_time': lead.toTime,
  //                       'phone': lead.phone,
  //                       'status': lead.status,
  //                     },
  //                     showToggle: false,
  //                     onWhatsApp: (phone) =>
  //                         dashboardController.isSubscribed.value
  //                             ? homeController.openWhatsApp(phone)
  //                             : showSubscriptionAlertDialog(
  //                                 Get.context!,
  //                                 'Subscription Required',
  //                                 'Your subscription is not active. Please subscribe to post a lead.',
  //                                 () => Get.toNamed(Routes.SUBSCRIPTION),
  //                               ),
  //                     onCall: (phone) => dashboardController.isSubscribed.value
  //                         ? homeController.makeCall(phone)
  //                         : showSubscriptionAlertDialog(
  //                             Get.context!,
  //                             'Subscription Required',
  //                             'Your subscription is not active. Please subscribe to post a lead.',
  //                             () => Get.toNamed(Routes.SUBSCRIPTION),
  //                           ),
  //                     onToggle: (_) {},
  //                   );
  //                 },
  //                 firstPageProgressIndicatorBuilder: (context) =>
  //                     ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: 1,
  //                   itemBuilder: (_, __) => leadCardShimmer(),
  //                 ),
  //                 newPageProgressIndicatorBuilder: (context) =>
  //                     ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: 1,
  //                   itemBuilder: (_, __) => leadCardShimmer(),
  //                 ),
  //                 noItemsFoundIndicatorBuilder: (context) =>
  //                     NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: ""),
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     }),
  //   ];
  // }

  // // Booking slivers include header + carousel + the paged sliver list
  // List<Widget> _bookingSlivers(
  //     PagingState<int, Post> state, NextPageCallback fetchNextPage) {
  //   return [
  //     // Emergency Services Section

  //     SliverToBoxAdapter(
  //         child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //       child: EmergencyServicesSection(),
  //     )),
  //     SliverToBoxAdapter(child: const SizedBox(height: 16)),

  //     // Banner: shimmer during loading or carousel when loaded
  //     SliverToBoxAdapter(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //         child: Obx(() {
  //           if (homeController.isBannerLoading.value) {
  //             return Shimmer.fromColors(
  //               baseColor: Colors.grey.shade300,
  //               highlightColor: Colors.grey.shade100,
  //               child: Container(
  //                 height: 20.h,
  //                 width: double.infinity,
  //                 margin: const EdgeInsets.symmetric(horizontal: 8),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //             );
  //           } else {
  //             return CarouselSlider(
  //               options: CarouselOptions(
  //                 height: 20.h,
  //                 autoPlay: true,
  //                 enlargeCenterPage: true,
  //                 viewportFraction: 0.9,
  //                 aspectRatio: 16 / 9,
  //                 autoPlayInterval: const Duration(seconds: 3),
  //               ),
  //               items: homeController.banners.map((banner) {
  //                 final imageUrl = banner.image?.trim().isNotEmpty == true
  //                     ? "${Config.baseUrl}${banner.image}"
  //                     : "https://via.placeholder.com/400x200.png?text=No+Image";

  //                 return Builder(
  //                   builder: (BuildContext context) {
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         border:
  //                             Border.all(color: Colors.grey.shade200, width: 2),
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(12),
  //                         child: Image.network(
  //                           imageUrl,
  //                           fit: BoxFit.contain,
  //                           width: MediaQuery.of(context).size.width,
  //                           errorBuilder: (context, error, stackTrace) {
  //                             return Container(
  //                               color: Colors.grey.shade200,
  //                               child: Center(
  //                                 child: Icon(Icons.broken_image,
  //                                     size: 40, color: Colors.grey),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 );
  //               }).toList(),
  //             );
  //           }
  //         }),
  //       ),
  //     ),

  //     SliverToBoxAdapter(child: const SizedBox(height: 20)),

  //     // Shared Leads header + filter button (as Sliver)
  //     SliverToBoxAdapter(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "Shared Leads",
  //               style: TextHelper.h6.copyWith(
  //                 fontFamily: semiBoldFont,
  //                 color: ColorsForApp.blackColor,
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 // existing filter bottom sheet
  //                 Get.bottomSheet(
  //                   Container(
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(20),
  //                         topRight: Radius.circular(20),
  //                       ),
  //                     ),
  //                     child: Form(
  //                       key: filterFormKey,
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Text("Filter Leads",
  //                               style: TextStyle(
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black)),
  //                           const SizedBox(height: 16),
  //                           TextFormField(
  //                             controller: homeController.fromLocationController,
  //                             style: TextHelper.size18.copyWith(
  //                                 color: ColorsForApp.blackColor,
  //                                 fontFamily: regularFont),
  //                             decoration: InputDecoration(
  //                               hintText: "Enter from loaction",
  //                               hintStyle: TextHelper.size18.copyWith(
  //                                 fontFamily: regularFont,
  //                               ),
  //                               errorStyle: TextStyle(fontSize: 13.sp),
  //                               labelText: "From Location",
  //                               labelStyle: TextHelper.size18.copyWith(
  //                                   color: ColorsForApp.blackColor,
  //                                   fontFamily: regularFont),
  //                               border: OutlineInputBorder(),
  //                             ),
  //                             onChanged: (value) =>
  //                                 homeController.fromLocation.value = value,
  //                             validator: (value) =>
  //                                 value == null || value.isEmpty
  //                                     ? 'Please enter From Location'
  //                                     : null,
  //                           ),
  //                           const SizedBox(height: 12),
  //                           TextFormField(
  //                             controller: homeController.toLocationController,
  //                             style: TextHelper.size18.copyWith(
  //                                 color: ColorsForApp.blackColor,
  //                                 fontFamily: regularFont),
  //                             decoration: InputDecoration(
  //                               labelText: "To Location",
  //                               hintText: "Enter to loaction",
  //                               hintStyle: TextHelper.size18.copyWith(
  //                                 fontFamily: regularFont,
  //                               ),
  //                               errorStyle: TextStyle(fontSize: 13.sp),
  //                               labelStyle: TextHelper.size18.copyWith(
  //                                   color: ColorsForApp.blackColor,
  //                                   fontFamily: regularFont),
  //                               border: OutlineInputBorder(),
  //                             ),
  //                             onChanged: (value) =>
  //                                 homeController.toLocation.value = value,
  //                             validator: (value) =>
  //                                 value == null || value.isEmpty
  //                                     ? 'Please enter To Location'
  //                                     : null,
  //                           ),
  //                           const SizedBox(height: 20),
  //                           Row(
  //                             children: [
  //                               Expanded(
  //                                 child: OutlinedButton(
  //                                   onPressed: () {
  //                                     homeController.clearFilter();
  //                                     activeLeadsPagingController.refresh();
  //                                     Get.back();
  //                                   },
  //                                   style: OutlinedButton.styleFrom(
  //                                     padding:
  //                                         EdgeInsets.symmetric(vertical: 14),
  //                                     shape: RoundedRectangleBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(12)),
  //                                   ),
  //                                   child: Text("Clear",
  //                                       style: TextHelper.size18
  //                                           .copyWith(fontFamily: boldFont)),
  //                                 ),
  //                               ),
  //                               SizedBox(width: 12),
  //                               Expanded(
  //                                 child: FilledButton(
  //                                   onPressed: () async {
  //                                     if (filterFormKey.currentState!
  //                                         .validate()) {
  //                                       // Form is valid, proceed with filtering
  //                                       homeController.applyFilter();
  //                                       activeLeadsPagingController.refresh();
  //                                       Get.back();
  //                                     }
  //                                   },
  //                                   style: FilledButton.styleFrom(
  //                                     padding:
  //                                         EdgeInsets.symmetric(vertical: 14),
  //                                     shape: RoundedRectangleBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(12)),
  //                                   ),
  //                                   child: Text("Apply",
  //                                       style: TextHelper.size18.copyWith(
  //                                           color: Colors.white,
  //                                           fontFamily: boldFont)),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //               child: Obx(() {
  //                 return Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //                   decoration: BoxDecoration(
  //                     color: homeController.isFilterApplied.value
  //                         ? ColorsForApp.red
  //                         : ColorsForApp.whiteColor,
  //                     borderRadius: BorderRadius.circular(20),
  //                     border: Border.all(
  //                       color: homeController.isFilterApplied.value
  //                           ? ColorsForApp.whiteColor
  //                           : ColorsForApp.blackColor,
  //                       width: 1.5,
  //                     ),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Icon(Icons.filter_alt_outlined,
  //                           color: homeController.isFilterApplied.value
  //                               ? ColorsForApp.whiteColor
  //                               : ColorsForApp.blackColor,
  //                           size: 16),
  //                       SizedBox(width: 4),
  //                       Text(
  //                           homeController.isFilterApplied.value
  //                               ? "Filtered"
  //                               : 'Filter',
  //                           style: TextHelper.size17.copyWith(
  //                             fontFamily: semiBoldFont,
  //                             color: homeController.isFilterApplied.value
  //                                 ? ColorsForApp.whiteColor
  //                                 : ColorsForApp.blackColor,
  //                           )),
  //                     ],
  //                   ),
  //                 );
  //               }),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),

  //     SliverToBoxAdapter(child: const SizedBox(height: 12)),

  //     // The paged sliver list (this will handle pagination)
  //     PagedSliverList<int, Post>(
  //       state: state,
  //       fetchNextPage: fetchNextPage,
  //       builderDelegate: PagedChildBuilderDelegate<Post>(
  //         itemBuilder: (context, item, index) {
  //           final lead = item;
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //             child: LeadCard(
  //               lead: {
  //                 'name': lead.vendorFullname,
  //                 'from': lead.locationFrom,
  //                 'to': lead.toLocation,
  //                 'price': lead.fare,
  //                 'car': lead.carModel,
  //                 'distance': lead.toLocationArea,
  //                 'date': lead.date,
  //                 'time': lead.time,
  //                 'phone': lead.vendorContact,
  //                 'note': lead.addOn,
  //                 'lead_status': lead.leadStatus,
  //               },
  //               onAccept: () => homeController.acceptLead(index),
  //               onWhatsApp: (phone) => homeController.openWhatsApp(phone),
  //               onCall: (phone) => homeController.makeCall(phone),
  //             ),
  //           );
  //         },
  //         firstPageProgressIndicatorBuilder: (context) => leadCardShimmer(),
  //         newPageProgressIndicatorBuilder: (context) => leadCardShimmer(),
  //         noItemsFoundIndicatorBuilder: (context) =>
  //             NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: ""),
  //       ),
  //     ),

  //     // small bottom spacing
  //     SliverToBoxAdapter(child: const SizedBox(height: 8)),
  //   ];
  // }

  void showBottomSheetForPostAvailability(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: postAvailablityFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top drag handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  Text("Post Availability", style: TextHelper.h6.copyWith(fontFamily: boldFont)),
                  const SizedBox(height: 16),

                  // Inputs
                  CustomTextField(controller: homeController.carController, label: "Enter Car Name/Model"),
                  const SizedBox(height: 12),
                  CustomTextField(controller: homeController.locationController, label: "Enter Location"),
                  const SizedBox(height: 12),

                  DateTile(
                    label: "Select From Date",
                    date: homeController.fromDate,
                    onTap: () => homeController.pickDate(context, true),
                  ),
                  const SizedBox(height: 12),

                  TimeTile(
                    label: "Select From Time",
                    time: homeController.fromTime,
                    onTap: () => homeController.pickTime(context, true),
                  ),
                  const SizedBox(height: 12),

                  DateTile(
                    label: "Select To Date",
                    date: homeController.toDate,
                    onTap: () => homeController.pickDate(context, false),
                  ),
                  const SizedBox(height: 12),

                  TimeTile(
                    label: "Select To Time",
                    time: homeController.toTime,
                    onTap: () => homeController.pickTime(context, false),
                  ),
                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Cancel", style: TextHelper.size18.copyWith(fontFamily: boldFont)),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ✅ Reactive Submit button
                      Expanded(
                        child: Obx(() {
                          return FilledButton(
                            onPressed: () async {
                              if (postAvailablityFormKey.currentState!.validate()) {
                                bool response = await homeController.postDriverAvailability(context);
                                if (response) {
                                  // close sheet
                                  Get.back();
                                  // success snackbar

                                  ShowSnackBar.success(
                                    title: 'Success',
                                    message: homeController.driverAvailabilityModel.value.message ?? 'Availability posted successfully',
                                  );
                                  homeController.showMyAvailability.value = true;
                                  myAvailablityPagingController.refresh();

                                  // clear inputs
                                  homeController.clearDriverAvailability();
                                } // Form is not valid
                              }
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: homeController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text("Submit", style: TextHelper.size18.copyWith(color: Colors.white, fontFamily: boldFont)),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Reusable tab widget
Widget _buildTab({
  required String title,
  required int index,
  required HomeController controller,
}) {
  final bool isSelected = controller.selectedIndex.value == index;

  return GestureDetector(
    onTap: () => controller.selectedIndex.value = index,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isSelected ? ColorsForApp.primaryDarkColor : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        title,
        style: TextHelper.size18.copyWith(
          color: isSelected ? Colors.white : Colors.black87,
          fontFamily: boldFont,
        ),
      ),
    ),
  );
}

/// For Post Availability Dialog Widgets
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const CustomTextField({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextHelper.size18,
      decoration: InputDecoration(
        labelText: label,
        errorStyle: TextHelper.size16.copyWith(
          fontFamily: semiBoldFont,
        ),
        labelStyle: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}

class DateTile extends StatelessWidget {
  final String label;
  final Rx<DateTime> date;
  final VoidCallback onTap;
  const DateTile({super.key, required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: onTap,
          splashColor: Colors.transparent, // 👈 no ripple
          highlightColor: Colors.transparent,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: ColorsForApp.primaryColor,
                size: 20,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              date.value.toLocal().toString().split(' ')[0],
              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
            ),
          ),
        ));
  }
}

class TimeTile extends StatelessWidget {
  final String label;
  final Rx<TimeOfDay> time;
  final VoidCallback onTap;
  const TimeTile({super.key, required this.label, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: onTap,
          splashColor: Colors.transparent, // 👈 no ripple
          highlightColor: Colors.transparent,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
              prefixIcon: Icon(Icons.access_time, color: ColorsForApp.primaryColor),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            child: Text(
              time.value.format(context),
              style: TextHelper.size18.copyWith(color: ColorsForApp.blackColor),
            ),
          ),
        ));
  }
}
