// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/search/logic/cubit/search_filter_cubit.dart';
import 'package:food_user_app/features/search/logic/cubit/search_filter_state.dart';

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

            // 🔹 Favorites Only
            BlocBuilder<SearchFilterCubit, SearchFilterState>(
              builder: (context, filterState) {
                final showFavoritesOnly = filterState.showFavoritesOnly;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: showFavoritesOnly ? 2 : 1,
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: showFavoritesOnly
                                ? AppColors.primaryOrange
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text("Favorites Only", style: mediumBold),
                        ],
                      ),
                      Switch(
                        value: showFavoritesOnly,
                        activeColor: AppColors.primaryOrange,
                        onChanged: (value) {
                          context.read<SearchFilterCubit>().toggleFavorites(
                            value,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            // 🔹 Combo Food
            BlocBuilder<SearchFilterCubit, SearchFilterState>(
              builder: (context, filterState) {
                final showComboOnly = filterState.showComboOnly;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.fastfood, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          const Text("Combo Food", style: mediumBold),
                        ],
                      ),
                      Switch(
                        value: showComboOnly,
                        activeColor: AppColors.primaryOrange,
                        onChanged: (value) {
                          context.read<SearchFilterCubit>().toggleCompoFood(
                            value,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Apply Filter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
