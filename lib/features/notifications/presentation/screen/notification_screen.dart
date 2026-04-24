import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/features/notifications/cubit/notificaiton_cubit.dart';
import 'package:food_user_app/features/notifications/presentation/widgets/notification_list.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Mark all as read (safe here)
    context.read<NotificationCubit>().markAllAsRead();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Notifications"),
      body: const NotificationList(),
    );
  }
}
