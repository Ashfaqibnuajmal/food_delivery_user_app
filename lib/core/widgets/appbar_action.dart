import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/foodai/presentation/screen/ai_chat.dart';
import 'package:food_user_app/features/notifications/cubit/notificaiton_cubit.dart';
import 'package:food_user_app/features/notifications/presentation/screen/notification_screen.dart';

class CustomAppBarActions extends StatefulWidget {
  final bool showChatBot;

  const CustomAppBarActions({super.key, this.showChatBot = true});

  @override
  State<CustomAppBarActions> createState() => _CustomAppBarActionsState();
}

class _CustomAppBarActionsState extends State<CustomAppBarActions> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _lastUnreadCount = 0;
  bool _isFirstLoad = true;

  Future<void> _playNotificationSound() async {
    await _audioPlayer.play(AssetSource('sounds/preview.mp3'));
  }

  void _handleNotificationSound(int count) {
    if (_isFirstLoad) {
      _lastUnreadCount = count;
      _isFirstLoad = false;
      return;
    }

    if (count > _lastUnreadCount) {
      _playNotificationSound();
    }

    _lastUnreadCount = count;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showChatBot)
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiChat()),
              );
            },
          ),

        StreamBuilder<QuerySnapshot>(
          stream: context.read<NotificationCubit>().getNotificationsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final unreadCountFuture = context
                  .read<NotificationCubit>()
                  .getUnreadCount();

              return FutureBuilder<int>(
                future: unreadCountFuture,
                builder: (context, unreadSnapshot) {
                  final count = unreadSnapshot.data ?? 0;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _handleNotificationSound(count);
                    }
                  });

                  return _buildNotificationIcon(context, count);
                },
              );
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _handleNotificationSound(0);
              }
            });

            return _buildNotificationIcon(context, 0);
          },
        ),
      ],
    );
  }

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
                builder: (_) => BlocProvider.value(
                  value: context.read<NotificationCubit>(),
                  child: const NotificationScreen(),
                ),
              ),
            );
          },
        ),
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
