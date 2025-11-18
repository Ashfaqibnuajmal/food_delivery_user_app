import 'package:flutter/material.dart';
import 'package:food_user_app/core/services/rating_service.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class CartItemInfo extends StatelessWidget {
  final String id;
  final String name;
  final bool isHalf;
  final double finalPrice;
  final bool isTodayOffer;

  const CartItemInfo({
    super.key,
    required this.id,
    required this.name,
    required this.isHalf,
    required this.finalPrice,
    required this.isTodayOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NAME
          Text(name, overflow: TextOverflow.ellipsis, style: mediumBold),

          const SizedBox(height: 5),

          // HALF / FULL
          Text(isHalf ? "(Half)" : "(Full)", style: greySmallTextStyle),

          const SizedBox(height: 5),

          // PRICE
          Text(
            "₹ ${finalPrice.toStringAsFixed(2)}",
            style: priceStyle(isTodayOffer: isTodayOffer),
          ),

          const SizedBox(height: 5),

          Container(
            padding: const EdgeInsets.only(right: 5),
            color: Colors.transparent,
            child: StreamBuilder<Map<String, dynamic>>(
              stream: RatingServices.getRatingData(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.primaryOrange,
                      ),
                      SizedBox(width: 3),
                      Text("..."),
                    ],
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.primaryOrange,
                      ),
                      SizedBox(width: 3),
                      Text("Add rating", style: ratingTextStyle),
                    ],
                  );
                }
                final data = snapshot.data!;
                final avg = (data['averageRating'] ?? "Add rating").toDouble();

                return Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 3),
                    Text(avg.toStringAsFixed(1), style: smallBold),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
