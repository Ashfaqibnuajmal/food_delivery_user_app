import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/features/notifications/cubit/notificaiton_cubit.dart';
import 'package:food_user_app/features/notifications/presentation/widgets/notification_list.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<NotificationCubit>().markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Notification's", showBack: true),
      body: NotificationList(),
    );
  }
}
