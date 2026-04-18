import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/ai/presentation/screen/ai_chat.dart';
import 'package:food_user_app/features/notifications/notification.dart';

class CustomAppBarActions extends StatelessWidget {
  final bool showChatBot; // control whether chatbot icon is shown

  const CustomAppBarActions({
    super.key,
    this.showChatBot = true, // default true
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🟢 ChatBot Icon (optional)
        if (showChatBot)
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiChat()),
              );
            },
          ),

        // 🟢 Notification Icon with badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
            ),
            // 🔴 Small badge at top-right
            Positioned(
              right: 13,
              top: 13,
              child: Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
