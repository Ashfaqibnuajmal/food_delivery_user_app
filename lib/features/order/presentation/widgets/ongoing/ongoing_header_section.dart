import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/order/services/history_service.dart';

class OngoingHeaderSection extends StatelessWidget {
  final String orderId;
  final String userName;
  final String currentStatus;
  final String createdText;
  const OngoingHeaderSection({
    super.key,
    required this.orderId,
    required this.userName,
    required this.currentStatus,
    required this.createdText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order ID', style: greySmallTextStyle),
                const SizedBox(height: 2),
                Text(HistoryService.formatOrderId(orderId), style: smallBold),
              ],
            ),
            if (userName.isNotEmpty) Text(userName, style: greySmallTextStyle),
          ],
        ),
        const SizedBox(height: 16),
        Text(currentStatus, style: bigBold),
        const SizedBox(height: 4),
        Text('Placed on $createdText', style: greySmallTextStyle),
      ],
    );
  }
}
