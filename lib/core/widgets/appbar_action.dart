import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/foodai/presentation/screen/ai_chat.dart';
import 'package:food_user_app/features/notifications/cubit/notificaiton_cubit.dart';
import 'package:food_user_app/features/notifications/presentation/screen/notification_screen.dart';

class CustomAppBarActions extends StatelessWidget {
  final bool showChatBot;

  const CustomAppBarActions({super.key, this.showChatBot = true});

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

        // 🔴 Notification Icon with REAL TIME badge
        StreamBuilder<QuerySnapshot>(
          stream: context.read<NotificationCubit>().getNotificationsStream(),
          builder: (context, snapshot) {
            int unreadCount = 0;

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              // ✅ Count unread based on lastSeenNotification
              final prefs = context.read<NotificationCubit>().getUnreadCount();

              return FutureBuilder<int>(
                future: prefs,
                builder: (context, unreadSnapshot) {
                  final count = unreadSnapshot.data ?? 0;

                  return _buildNotificationIcon(context, count);
                },
              );
            }

            return _buildNotificationIcon(context, unreadCount);
          },
        ),
      ],
    );
  }

  // ✅ Notification icon with badge
  Widget _buildNotificationIcon(BuildContext context, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => NotificationCubit(),
                  child: const NotificationScreen(),
                ),
              ),
            );
          },
        ),
        // 🔴 Badge — only show if unread count > 0
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              height: 18,
              width: 18,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
