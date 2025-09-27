import 'package:QuickCab/Screens/history_module/lead_history_model.dart';
import 'package:QuickCab/Screens/home_page_module/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../widgets/no_data_found.dart';
import '../../widgets/shimmer_widget.dart';
import '../home_page_module/home_widgets/lead_card.dart';

class LeadHistoryScreen extends StatefulWidget {
  const LeadHistoryScreen({super.key});

  @override
  State<LeadHistoryScreen> createState() => _LeadHistoryScreenState();
}

class _LeadHistoryScreenState extends State<LeadHistoryScreen> {
  HomeController homeController = Get.find();

  late final historyPagingController = PagingController<int, Leads>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (int pageKey) async {
      final response = await homeController.fetchLeadsHistory(pageKey);
      final items = (response.leads ?? []).where((lead) => lead.leadStatus?.toLowerCase() == 'booked').toList();
      return items;
    },
  );
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        historyPagingController.refresh();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: PagingListener(
          controller: historyPagingController,
          builder: (context, state, fetchNextPage) {
            return PagedListView<int, Leads>(
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageProgressIndicatorBuilder: (context) {
                  return leadCardShimmer();
                },
                newPageProgressIndicatorBuilder: (context) {
                  return leadCardShimmer();
                },
                noItemsFoundIndicatorBuilder: (context) {
                  return NoDataFoundScreen(title: "NO LEADS FOUND", subTitle: "");
                },
                itemBuilder: (context, item, index) {
                  final lead = item;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
