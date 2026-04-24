import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/notifications/utils/date_time_utils.dart';

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final createdAt = data['createdAt'] as Timestamp?;

    return Card(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.black12),
      ),
      margin: const EdgeInsets.all(3),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 80, // all cards at least this tall
          maxHeight: 120, // never grows beyond this
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // center icon & text vertically
            children: [
              // 🔔 Icon Card
              Card(
                elevation: 2,
                color: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Title + Message
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // shrink to content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row with time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data['title'] ?? '',
                            style: bigBold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (createdAt != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              DateTimeHelper.timeAgo(createdAt),
                              style: DateAndTime,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Message
                    Text(
                      data['message'] ?? '',
                      style: smallBold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
