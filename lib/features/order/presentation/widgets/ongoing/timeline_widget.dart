import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({
    super.key,
    required this.step,
    required this.isLast,
    required this.isActive,
  });

  final Map<String, Object> step;
  final bool isLast;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.primaryOrange : Colors.black,
                  width: 2,
                ),
                color: isActive
                    ? AppColors.primaryOrange.withOpacity(0.1)
                    : null,
              ),
              child: Icon(
                step["icon"] as IconData,
                size: 16,
                color: Colors.black,
              ),
            ),

            if (!isLast)
              Container(
                height: 40,
                width: 2,
                color: isActive ? AppColors.primaryOrange : Colors.black,
              ),
          ],
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step["title"] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            Text(
              step["time"] as String,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
