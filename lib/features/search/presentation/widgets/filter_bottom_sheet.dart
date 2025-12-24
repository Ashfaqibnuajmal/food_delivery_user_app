import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: const Text("Filter Foods.", style: bigBold)),
            const SizedBox(height: 20),

            // 🔹 Favorites
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Favorites", style: mediumBold),
                  Switch(
                    value: false,
                    activeColor: AppColors.primaryOrange,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),

            // 🔹 Combo Food
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Combo Food", style: mediumBold),
                  Switch(
                    value: false,
                    activeColor: AppColors.primaryOrange,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Price Range
            const Text("Price Range", style: mediumBold),
            const SizedBox(height: 10),
            RangeSlider(
              values: const RangeValues(10, 150),
              min: 10,
              max: 150,
              divisions: 14,
              labels: const RangeLabels("₹10", "₹150"),
              activeColor: AppColors.primaryOrange,
              onChanged: (value) {},
            ),

            const SizedBox(height: 20),

            // 🔹 Rating
            const Text("Rating", style: mediumBold),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: List.generate(
                5,
                (index) => Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text("${index + 1}+"),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text("Apply Filter", style: mediumBold),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
