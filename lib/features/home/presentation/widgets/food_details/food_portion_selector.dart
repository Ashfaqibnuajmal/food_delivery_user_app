import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/home/logic/cubit/food_portion_cubit.dart';
import 'package:shimmer/shimmer.dart';

class FoodPortionSelector extends StatelessWidget {
  final bool isHalfAvailable;
  final String image;
  final int price;
  final int halfPrice;

  const FoodPortionSelector({
    super.key,
    required this.isHalfAvailable,
    required this.image,
    required this.price,
    required this.halfPrice,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPortionCubit, bool>(
      builder: (context, isHalfSelected) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (isHalfAvailable)
              _PortionCard(
                title: "Half",
                price: halfPrice,
                image: image,
                isSelected: isHalfSelected,
                onTap: () => context.read<FoodPortionCubit>().selectHalf(),
              ),

            // Full Portion
            _PortionCard(
              title: "Full",
              price: price,
              image: image,
              isSelected: !isHalfSelected,
              onTap: () => context.read<FoodPortionCubit>().selectFull(),
            ),
          ],
        );
      },
    );
  }
}

/// 🧱 Internal reusable portion card widget
class _PortionCard extends StatelessWidget {
  final String title;
  final int price;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const _PortionCard({
    required this.title,
    required this.price,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withOpacity(0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood, color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(height: 5),
            Text(title, style: bigBold),
            const SizedBox(height: 5),
            Text("₹$price.00", style: mediumBold),
          ],
        ),
      ),
    );
  }
}
