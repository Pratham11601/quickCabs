import 'package:flutter/material.dart';
import 'package:own_idea/utils/app_colors.dart';
import 'package:own_idea/utils/text_styles.dart';
import 'package:get/get.dart';
class Package {
  final String name;
  final String description;
  final int durationInDays;
  final int pricePerDay;
  final int totalPrice;
  final Color color;
  final bool isPopular;

  Package({
    required this.name,
    required this.description,
    required this.durationInDays,
    required this.pricePerDay,
    required this.totalPrice,
    required this.color,
    this.isPopular = false,
  });
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<Package> packages = [
    Package(
      name: "Silver Package",
      description: "Best for starter",
      durationInDays: 30,
      pricePerDay: 17,
      totalPrice: 499,
      color: Colors.blueAccent,
    ),
    Package(
      name: "Gold Package",
      description: "Great Value",
      durationInDays: 90,
      pricePerDay: 13,
      totalPrice: 1170,
      color: Colors.redAccent,
      isPopular: true,
    ),
    Package(
      name: "Platinum Package",
      description: "Ultimate Experience",
      durationInDays: 180,
      pricePerDay: 10,
      totalPrice: 1800,
      color: Colors.green,
    ),
  ];

  int? selectedPackageIndex;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: ()=> Get.back(),child: const Icon(Icons.arrow_back, color: Colors.black, size: 25)),
        title: Text(
          'Subscription',
          style: TextHelper.size20.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsForApp.orange,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Message about selection ABOVE the packages list
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                selectedPackageIndex == null
                    ? 'Please select a package'
                    : 'Selected Package: ${packages[selectedPackageIndex!].name}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Packages List (make it smaller to allow space for button below)
            Expanded(
              child: ListView.separated(
                itemCount: packages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  final isSelected = selectedPackageIndex == index;
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        selectedPackageIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? pkg.color.withOpacity(0.15) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? pkg.color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: selectedPackageIndex,
                            activeColor: pkg.color,
                            onChanged: (value) {
                              setState(() {
                                selectedPackageIndex = value;
                              });
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pkg.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isSelected ? pkg.color : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  pkg.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${pkg.durationInDays} days · ₹${pkg.pricePerDay} per day",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "₹${pkg.totalPrice}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: isSelected ? pkg.color : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Subscribe button below the package list, with margin and padding
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedPackageIndex != null
                      ? () {
                    final selectedPackage = packages[selectedPackageIndex!];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Subscribed to ${selectedPackage.name} for ₹${selectedPackage.totalPrice}'),
                      ),
                    );
                    // Implement subscription logic here
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: selectedPackageIndex != null ? ColorsForApp.orange : Colors.grey,
                    textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text(
                    'Subscribe',
                    style: TextHelper.size20.copyWith(color: ColorsForApp.whiteColor),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
