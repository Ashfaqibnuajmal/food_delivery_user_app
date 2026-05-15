import 'package:flutter/material.dart';
import 'package:food_user_app/features/order/controller/completed_order_controller.dart';
import 'package:food_user_app/features/order/presentation/widgets/completed/complete_order_action_button.dart';
import 'package:food_user_app/features/order/presentation/widgets/completed/completed_order_image_stack.dart';
import 'package:food_user_app/features/order/presentation/widgets/completed/completed_order_info_section.dart';
import 'package:food_user_app/features/order/presentation/widgets/completed/reorder_dialog.dart';

class CompletedOrderCard extends StatelessWidget {
  const CompletedOrderCard({super.key, required this.orderData});

  final Map<String, dynamic> orderData;

  @override
  Widget build(BuildContext context) {
    final controller = CompletedOrderController(orderData: orderData);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.grey.shade200, width: 1.5),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),

            blurRadius: 14,
            spreadRadius: 0,

            offset: const Offset(0, 5),
          ),

          BoxShadow(
            color: Colors.black.withOpacity(0.03),

            blurRadius: 4,

            offset: const Offset(0, 1),
          ),
        ],
      ),

      child: Column(
        children: [
          /// TOP SECTION
          Padding(
            padding: const EdgeInsets.all(14),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                /// IMAGE STACK
                CompletedOrderImageStack(images: controller.foodImages),

                const SizedBox(width: 16),

                /// ORDER INFO
                CompletedOrderInfoSection(
                  foodNames: controller.foodNames,
                  dateText: controller.dateText,
                  totalAmount: controller.totalAmount,
                  itemCount: controller.itemCount,
                ),
              ],
            ),
          ),

          /// DIVIDER
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

          /// ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

            child: CompletedOrderActionButtons(
              onReorderTap: () => showReorderDialog(context),
            ),
          ),
        ],
      ),
    );
  }
}
