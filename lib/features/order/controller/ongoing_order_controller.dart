import 'package:flutter/material.dart';
import 'package:food_user_app/features/order/services/history_service.dart';
import 'package:intl/intl.dart';

class OngoingOrderController {
  OngoingOrderController({required this.orderData});

  final Map<String, dynamic> orderData;

  /// ======================================================
  /// ORDER STEPS
  /// ======================================================

  final List<Map<String, dynamic>> steps = const [
    {'title': 'Making', 'icon': Icons.restaurant},
    {'title': 'Packing', 'icon': Icons.inventory},
    {'title': 'Out for Delivery', 'icon': Icons.delivery_dining},
    {'title': 'Delivered', 'icon': Icons.check_circle},
  ];

  /// ======================================================
  /// ORDER DETAILS
  /// ======================================================

  String get orderId => orderData['orderId'] ?? 'N/A';

  String get currentStatus => (orderData['orderStatus'] ?? 'Making').toString();

  String get deliveryAddress =>
      orderData['deliveryAddress'] ?? 'No Address Provided';

  dynamic get totalAmount => orderData['totalAmount'] ?? 0;

  String get userName => orderData['userName'] ?? '';

  String get phoneNumber => orderData['phoneNumber'] ?? '';

  /// ======================================================
  /// ACTIVE INDEX
  /// ======================================================

  int get activeIndex {
    int index = steps.indexWhere((step) => step['title'] == currentStatus);

    if (index == -1) {
      return 0;
    }

    return index;
  }

  /// ======================================================
  /// CREATED DATE
  /// ======================================================

  dynamic get createdRaw => orderData['createdAt'];

  dynamic get createdTimestamp => HistoryService.safeToTimestamp(createdRaw);

  String get createdText => HistoryService.formatDate(createdTimestamp);

  /// ======================================================
  /// STATUS MAP
  /// ======================================================

  Map<String, dynamic> get statusMap {
    final rawMap = orderData['statusTimestamps'];

    return (rawMap is Map) ? Map<String, dynamic>.from(rawMap) : {};
  }

  /// ======================================================
  /// TIMELINE TIMES
  /// ======================================================

  List<String> get simulatedTimes {
    List<String> times = List.generate(steps.length, (_) => '--');

    if (createdTimestamp != null) {
      DateTime baseTime = createdTimestamp.toDate();

      for (int i = 0; i < steps.length; i++) {
        final title = steps[i]['title'] as String;

        final ts = HistoryService.safeToTimestamp(statusMap[title]);

        if (ts != null) {
          times[i] = HistoryService.formatDate(ts);

          baseTime = ts.toDate();
        } else {
          baseTime = baseTime.add(const Duration(minutes: 5));

          times[i] = DateFormat('MMM d, yyyy - hh:mm a').format(baseTime);
        }
      }
    }

    return times;
  }

  /// ======================================================
  /// FOOD ITEMS
  /// ======================================================

  List<Map<String, dynamic>> get foodItems {
    final rawItems = orderData['foodItems'];

    return (rawItems is List)
        ? List<Map<String, dynamic>>.from(
            rawItems.map((e) => Map<String, dynamic>.from(e as Map)),
          )
        : [];
  }

  /// ======================================================
  /// FOOD NAMES
  /// ======================================================

  List<String> get foodNames {
    return foodItems.map((item) {
      return item['name']?.toString() ?? '';
    }).toList();
  }

  /// ======================================================
  /// FOOD IMAGES
  /// ======================================================

  List<String> get foodImages {
    return foodItems.map((item) {
      return item['imageUrl']?.toString() ?? '';
    }).toList();
  }

  /// ======================================================
  /// ITEMS SUMMARY
  /// ======================================================

  String get itemsSummary {
    return foodItems
        .map((item) {
          final name = item['name'] ?? '';
          final qty = item['quantity'] ?? 1;

          return '$name x$qty';
        })
        .join(', ');
  }
}
