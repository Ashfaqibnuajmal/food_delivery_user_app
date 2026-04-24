import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  NotificationCubit() : super(NotificationInitial());

  // ✅ Real time stream of all notifications
  Stream<QuerySnapshot> getNotificationsStream() {
    return _db
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ✅ Get unread count based on last seen time
  Future<int> getUnreadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeen = prefs.getInt('lastSeenNotification') ?? 0;
      final lastSeenTime = DateTime.fromMillisecondsSinceEpoch(lastSeen);

      final snapshot = await _db
          .collection('notifications')
          .where('createdAt', isGreaterThan: Timestamp.fromDate(lastSeenTime))
          .get();

      return snapshot.docs.length;
    } catch (e) {
      log('Error getting unread count: $e');
      return 0;
    }
  }

  // ✅ Mark all as read when user opens notification screen
  Future<void> markAllAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'lastSeenNotification',
        DateTime.now().millisecondsSinceEpoch,
      );
      emit(NotificationInitial());
    } catch (e) {
      log('Error marking as read: $e');
    }
  }
}
