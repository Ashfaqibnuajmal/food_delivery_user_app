import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryService {
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

  static String formatDate(Timestamp? ts) {
    if (ts == null) return '--';
    return DateFormat('MMM d, yyyy - hh:mm a').format(ts.toDate());
  }

  static String formatOrderId(dynamic id) {
    if (id == null) return '#ORD-00000';
    String numPart = id.toString().padLeft(5, '0');
    return '#ORD-$numPart';
  }

  // ✅ Fixed: filter by current user's userId
  static Stream<QuerySnapshot> getAllOrdersStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('userId', isEqualTo: uid)
        .snapshots(); // ✅ removed orderBy — no composite index needed
  }

  static Future<void> placeOrder({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> address,
    required String userId,
  }) async {
    try {
      final doc = FirebaseFirestore.instance.collection('Orders').doc();
      final now = Timestamp.now();
      await doc.set({
        'orderId': doc.id,
        'userId': userId,
        'orderStatus': 'Making',
        'createdAt': now,
        'statusTimestamps': {'Making': now},
        'items': items,
        'address': address,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
