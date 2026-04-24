abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<Map<String, dynamic>> notifications;
  final int unreadCount;

  NotificationLoaded({required this.notifications, required this.unreadCount});
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
