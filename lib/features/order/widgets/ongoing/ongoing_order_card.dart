import 'package:flutter/material.dart';
import 'package:food_user_app/features/order/services/history_service.dart';
import 'package:food_user_app/features/order/widgets/ongoing/need_help_button.dart';
import 'package:food_user_app/features/order/widgets/ongoing/ongoing_food_card.dart';
import 'package:food_user_app/features/order/widgets/ongoing/ongoing_header_section.dart';
import 'package:food_user_app/features/order/widgets/ongoing/timeline_widget.dart';
import 'package:intl/intl.dart';

class OngoingOrderCard extends StatelessWidget {
  const OngoingOrderCard({super.key, required this.orderData});

  final Map<String, dynamic> orderData;

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Making', 'icon': Icons.restaurant},
      {'title': 'Packing', 'icon': Icons.inventory},
      {'title': 'Out for Delivery', 'icon': Icons.delivery_dining},
      {'title': 'Delivered', 'icon': Icons.check_circle},
    ];

    final orderId = orderData['orderId'] ?? 'N/A';
    final currentStatus = (orderData['orderStatus'] ?? 'Making').toString();
    final deliveryAddress =
        orderData['deliveryAddress'] ?? 'No Address Provided';
    final totalAmount = orderData['totalAmount'] ?? 0;
    final userName = orderData['userName'] ?? '';
    final phoneNumber = orderData['phoneNumber'] ?? '';

    int activeIndex = steps.indexWhere((s) => s['title'] == currentStatus);
    if (activeIndex == -1) activeIndex = 0;

    final createdRaw = orderData['createdAt'];
    final createdTs = HistoryService.safeToTimestamp(createdRaw);
    final createdText = HistoryService.formatDate(createdTs);

    final rawMap = orderData['statusTimestamps'];
    final Map<String, dynamic> statusMap = (rawMap is Map)
        ? Map<String, dynamic>.from(rawMap)
        : {};

    // ✅ Fixed: always initialize with '--' fallback first
    List<String> simulatedTimes = List.generate(steps.length, (_) => '--');

    if (createdTs != null) {
      DateTime baseTime = createdTs.toDate();
      for (int i = 0; i < steps.length; i++) {
        final title = steps[i]['title'] as String;
        final ts = HistoryService.safeToTimestamp(statusMap[title]);
        if (ts != null) {
          simulatedTimes[i] = HistoryService.formatDate(ts);
          baseTime = ts.toDate();
        } else {
          baseTime = baseTime.add(const Duration(minutes: 5));
          simulatedTimes[i] = DateFormat(
            'MMM d, yyyy - hh:mm a',
          ).format(baseTime);
        }
      }
    }

    // ✅ Fixed: use 'foodItems' key matching Firestore
    final rawItems = orderData['foodItems'];
    final foodItems = (rawItems is List)
        ? List<Map<String, dynamic>>.from(
            rawItems.map((e) => Map<String, dynamic>.from(e as Map)),
          )
        : [];

    final foodNames = foodItems
        .map((item) => item['name']?.toString() ?? '')
        .toList();
    final foodImages = foodItems
        .map((item) => item['imageUrl']?.toString() ?? '')
        .toList();

    // Build items summary: "Meals x1, Water x1"
    final itemsSummary = foodItems
        .map((item) {
          final name = item['name'] ?? '';
          final qty = item['quantity'] ?? 1;
          return '$name x$qty';
        })
        .join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID & date
          OngoingHeaderSection(
            orderId: orderId,
            userName: userName,
            currentStatus: currentStatus,
            createdText: createdText,
          ),

          const SizedBox(height: 20),

          // Timeline
          Column(
            children: List.generate(steps.length, (i) {
              return TimelineWidget(
                step: {
                  'icon': steps[i]['icon'] as IconData,
                  'title': steps[i]['title'] as String,
                  'time': simulatedTimes[i],
                },
                isLast: i == steps.length - 1,
                isActive: i <= activeIndex,
              );
            }),
          ),

          const SizedBox(height: 24),

          // Food card
          OngoingFoodCard(
            foodImages: foodImages,
            foodNames: foodNames,
            itemsSummary: itemsSummary,
            totalAmount: totalAmount,
            deliveryAddress: deliveryAddress,
            phoneNumber: phoneNumber,
          ),

          const SizedBox(height: 20),

          // Need Help button
          const NeedHelpButton(),

          const SizedBox(height: 16),
          const Divider(thickness: 0.5),
        ],
      ),
    );
  }
}
