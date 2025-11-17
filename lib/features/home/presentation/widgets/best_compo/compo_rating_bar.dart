import 'package:flutter/material.dart';
import 'package:food_user_app/core/services/rating_service.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class CompoRatingBar extends StatelessWidget {
  final String id;

  const CompoRatingBar({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -3,
      left: -8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        color: Colors.transparent,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: RatingServices.getRatingData(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Row(
                children: [
                  Icon(Icons.star, size: 14, color: AppColors.primaryOrange),
                  SizedBox(width: 3),
                  Text("..."),
                ],
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Row(
                children: [
                  Icon(Icons.star, size: 14, color: AppColors.primaryOrange),
                  SizedBox(width: 3),
                  Text("0.0", style: ratingTextStyle),
                ],
              );
            }

            final data = snapshot.data!;
            final avg = (data['averageRating'] ?? 0.0).toDouble();

            return Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 14,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 3),
                Text(avg.toStringAsFixed(1), style: ratingTextStyle),
              ],
            );
          },
        ),
      ),
    );
  }
}
