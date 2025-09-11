import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget leadCardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 16, width: 120, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 14, width: 200, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 14, width: 100, color: Colors.white),
        ],
      ),
    ),
  );
}

Widget rideRequestCardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

Widget statsCardShimmer() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

Widget shimmerLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      children: [
        statsCardShimmer(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // number of shimmer cards
            itemBuilder: (_, __) => leadCardShimmer(),
          ),
        ),
      ],
    ),
  );
}
