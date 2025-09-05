// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:sizer/sizer.dart';
// import '../controller/home_controller.dart';
//
// class BookingAvailableButton extends StatefulWidget {
//   const BookingAvailableButton({super.key});
//
//   @override
//   State<BookingAvailableButton> createState() => _BookingAvailableButtonState();
// }
//
// class _BookingAvailableButtonState extends State<BookingAvailableButton> {
//   final HomeController homeController = Get.put(HomeController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: 88.w,
//           padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h), // smaller padding
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Obx(() => Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   homeController.selectedIndex.value = 0;
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h), // smaller vertical
//                   decoration: BoxDecoration(
//                     color: homeController.selectedIndex.value == 0 ? Colors.white : Colors.transparent,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: homeController.selectedIndex.value == 0
//                         ? [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 5,
//                         offset: const Offset(0, 2),
//                       ),
//                     ]
//                         : [],
//                   ),
//                   child: Text(
//                     "Booking",
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               GestureDetector(
//                 onTap: () {
//                   homeController.selectedIndex.value = 1;
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h), // smaller vertical
//                   decoration: BoxDecoration(
//                     color: homeController.selectedIndex.value == 1 ? Colors.white : Colors.transparent,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: homeController.selectedIndex.value == 1
//                         ? [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 5,
//                         offset: const Offset(0, 2),
//                       ),
//                     ]
//                         : [],
//                   ),
//                   child: Text(
//                     "Available",
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )),
//         ),
//       ),
//     );
//   }
// }
