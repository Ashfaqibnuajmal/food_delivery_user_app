import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeHelper {
  static String formatSmartDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    final time =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    // ✅ Today
    if (difference == 0 &&
        now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return time;
    }

    // ✅ Yesterday
    if (difference == 1) {
      return "${_weekday(date.weekday)} $time";
    }

    // ✅ Older
    return "${_weekday(date.weekday)} ${date.day} ${_month(date.month)} · $time";
  }

  static String _weekday(int day) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return days[day - 1];
  }

  static String _month(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  static String timeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final diff = now.difference(timestamp.toDate());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
