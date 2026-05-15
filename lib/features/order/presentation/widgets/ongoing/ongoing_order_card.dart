import 'package:flutter/material.dart';
import 'package:food_user_app/features/order/controller/ongoing_order_controller.dart';
import 'package:food_user_app/features/order/presentation/widgets/ongoing/need_help_button.dart';
import 'package:food_user_app/features/order/presentation/widgets/ongoing/ongoing_food_card.dart';
import 'package:food_user_app/features/order/presentation/widgets/ongoing/ongoing_header_section.dart';
import 'package:food_user_app/features/order/presentation/widgets/ongoing/timeline_widget.dart';

class OngoingOrderCard extends StatelessWidget {
  const OngoingOrderCard({super.key, required this.orderData});

  final Map<String, dynamic> orderData;

  @override
  Widget build(BuildContext context) {
    final controller = OngoingOrderController(orderData: orderData);

    return Container(
      margin: const EdgeInsets.only(bottom: 30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// HEADER
          OngoingHeaderSection(
            orderId: controller.orderId,
            userName: controller.userName,
            currentStatus: controller.currentStatus,
            createdText: controller.createdText,
          ),

          const SizedBox(height: 20),

          /// TIMELINE
          Column(
            children: List.generate(controller.steps.length, (i) {
              return TimelineWidget(
                step: {
                  'icon': controller.steps[i]['icon'] as IconData,

                  'title': controller.steps[i]['title'] as String,

                  'time': controller.simulatedTimes[i],
                },

                isLast: i == controller.steps.length - 1,

                isActive: i <= controller.activeIndex,
              );
            }),
          ),

          const SizedBox(height: 24),

          /// FOOD CARD
          OngoingFoodCard(
            foodImages: controller.foodImages,
            foodNames: controller.foodNames,
            itemsSummary: controller.itemsSummary,
            totalAmount: controller.totalAmount,
            deliveryAddress: controller.deliveryAddress,
            phoneNumber: controller.phoneNumber,
          ),

          const SizedBox(height: 20),

          /// NEED HELP BUTTON
          const NeedHelpButton(),

          const SizedBox(height: 16),

          const Divider(thickness: 0.5),
        ],
      ),
    );
  }
}
