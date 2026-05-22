import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  NotificationCubit() : super(NotificationInitial());

  Stream<QuerySnapshot> getNotificationsStream() {
    return _db
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<int> getUnreadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeen = prefs.getInt('lastSeenNotification') ?? 0;

      final snapshot = await _db
          .collection('notifications')
          .where(
            'createdAt',
            isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(lastSeen),
          )
          .get();

      return snapshot.docs.length;
    } catch (e) {
      log('Error getting unread count: $e');
      return 0;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final latestSnapshot = await _db
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (latestSnapshot.docs.isEmpty) {
        await prefs.setInt(
          'lastSeenNotification',
          DateTime.now().millisecondsSinceEpoch,
        );
        emit(NotificationInitial());
        return;
      }

      final latestData = latestSnapshot.docs.first.data();
      final latestCreatedAt = latestData['createdAt'];

      if (latestCreatedAt is Timestamp) {
        await prefs.setInt(
          'lastSeenNotification',
          latestCreatedAt.millisecondsSinceEpoch,
        );
      } else {
        await prefs.setInt(
          'lastSeenNotification',
          DateTime.now().millisecondsSinceEpoch,
        );
      }

      emit(NotificationInitial());
    } catch (e) {
      log('Error marking as read: $e');
    }
  }
}
