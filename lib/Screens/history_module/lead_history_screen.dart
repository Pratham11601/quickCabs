import 'package:QuickCab/Screens/home_page_module/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../widgets/common_widgets.dart';
import '../../widgets/no_data_found.dart';
import '../home_page_module/home_widgets/lead_card.dart';
import '../home_page_module/model/active_lead_model.dart';

class LeadHistoryScreen extends StatefulWidget {
  const LeadHistoryScreen({super.key});

  @override
  State<LeadHistoryScreen> createState() => _LeadHistoryScreenState();
}

class _LeadHistoryScreenState extends State<LeadHistoryScreen> {
  HomeController homeController = Get.find();
  late final historyPagingController = PagingController<int, Post>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (int pageKey) async {
      final response = await homeController.fetchLeadsHistory(pageKey);
      final items = response.posts;
      return items;
    },
  );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:   PagingListener(
        controller: historyPagingController,
        builder: (context, state, fetchNextPage) {
          return PagedListView<int, Post>(
            state: state,
            fetchNextPage: fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) {
                return LoadingOverlay(
                  isLoading: true,
                  child: SizedBox.expand(),
                );
              },
              newPageProgressIndicatorBuilder: (context) {
                return LoadingOverlay(
                  isLoading: true,
                  child: SizedBox.expand(),
                );
              },
              noItemsFoundIndicatorBuilder: (context) {
                return NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: "");
              },
              itemBuilder: (context, item, index) {
                final lead = item;

                return LeadCard(
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
              );
              },
            ),
          );
        },
      ),
    );
  }
}
