import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/shimmer_food_grid.dart';
import 'package:food_user_app/features/notifications/cubit/notificaiton_cubit.dart';
import 'package:food_user_app/features/notifications/utils/date_time_utils.dart';
import 'notification_tile.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<NotificationCubit>().getNotificationsStream(),
      builder: (context, snapshot) {
        // ⏳ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: ShimmerLoader(type: ShimmerLayoutType.list, itemCount: 8),
          );
        }

        // 📭 Empty
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_rounded,
                  size: 70,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text('No notifications yet', style: emptyTextStyle),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final createdAt = data['createdAt'] as Timestamp?;
            final date = createdAt?.toDate();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotificationTile(data: data),

                if (date != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 4,
                      bottom: 10,
                    ),
                    child: Text(
                      DateTimeHelper.formatSmartDate(date),
                      style: DateAndTime,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
