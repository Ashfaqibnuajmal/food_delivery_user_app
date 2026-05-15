import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class CompletedOrderInfoSection extends StatelessWidget {
  const CompletedOrderInfoSection({
    super.key,
    required this.foodNames,
    required this.dateText,
    required this.totalAmount,
    required this.itemCount,
  });

  final String foodNames;
  final String dateText;
  final dynamic totalAmount;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// FOOD NAMES
          Text(
            foodNames.isNotEmpty ? foodNames : 'Food Order',

            style: mediumBold,

            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          /// DATE
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 12,
                color: Colors.grey.shade400,
              ),

              const SizedBox(width: 4),

              Expanded(child: Text(dateText, style: greySmallTextStyle)),
            ],
          ),

          const SizedBox(height: 10),

          /// PRICE + ITEM COUNT
          Row(
            children: [
              /// PRICE CHIP
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.08),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text('₹ $totalAmount', style: orangeBoldSmallTextStyle),
              ),

              const SizedBox(width: 8),

              /// ITEM COUNT CHIP
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  '$itemCount item${itemCount != 1 ? 's' : ''}',

                  style: greySmallTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
