import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderServices {
  // ✅ Safe conversion helper
  static Timestamp? safeToTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value;
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return Timestamp.fromDate(parsed);
    }
    if (value is int) {
      try {
        return Timestamp.fromMillisecondsSinceEpoch(value);
      } catch (_) {}
    }
    return null;
  }

  // ✅ Date formatting helper
  static String formatDate(Timestamp? ts) {
    if (ts == null) return "--";
    return DateFormat('MMM d, yyyy - hh:mm a').format(ts.toDate());
  }

  // ✅ Order ID formatter
  static String formatOrderId(dynamic id) {
    if (id == null) return "#ORD-00000";
    String numPart = id.toString().padLeft(5, '0');
    return "#ORD-$numPart";
  }

  // ✅ Stream for all orders
  static Stream<QuerySnapshot> getAllOrdersStream() {
    return FirebaseFirestore.instance
        .collection("Orders")
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
