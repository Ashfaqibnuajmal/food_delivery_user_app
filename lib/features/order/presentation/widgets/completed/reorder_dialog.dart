import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

void showReorderDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 36,
              color: AppColors.primaryOrange,
            ),
          ),

          const SizedBox(height: 14),

          /// TITLE
          const Text('Re-order items?', style: mediumBold),

          const SizedBox(height: 6),

          /// DESCRIPTION
          Text(
            'This will add the same items to your cart.',
            textAlign: TextAlign.center,
            style: greySmallTextStyle,
          ),

          const SizedBox(height: 22),

          /// BUTTONS
          Row(
            children: [
              /// CANCEL BUTTON
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('Cancel', style: smallBold),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              /// CONFIRM BUTTON
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(dialogContext);
                    onConfirm();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Yes, Re-order',
                      style: whiteBoldSmallTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
