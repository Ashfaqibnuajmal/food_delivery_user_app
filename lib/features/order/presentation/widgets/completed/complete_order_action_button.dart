import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class CompletedOrderActionButtons extends StatelessWidget {
  const CompletedOrderActionButtons({super.key, required this.onReorderTap});

  final VoidCallback onReorderTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// DELIVERED BUTTON
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),

            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: Colors.green.withOpacity(0.2),
                width: 1,
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 15,
                  color: Colors.green.shade600,
                ),

                const SizedBox(width: 5),

                Text('Delivered', style: greenTextStyle),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// REORDER BUTTON
        Expanded(
          child: GestureDetector(
            onTap: onReorderTap,

            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),

              decoration: BoxDecoration(
                color: AppColors.primaryOrange,

                borderRadius: BorderRadius.circular(12),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),

                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.replay_rounded, size: 14, color: Colors.white),

                  SizedBox(width: 5),

                  Text('Re Order', style: whiteBoldSmallTextStyle),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
