import 'package:food_user_app/features/order/services/history_service.dart';

class CompletedOrderController {
  CompletedOrderController({required this.orderData});

  final Map<String, dynamic> orderData;

  /// ======================================================
  /// FOOD ITEMS
  /// ======================================================

  List<Map<String, dynamic>> get foodItems {
    final rawItems = orderData['foodItems'];

    return (rawItems is List)
        ? List<Map<String, dynamic>>.from(
            rawItems.map((e) => Map<String, dynamic>.from(e as Map)),
          )
        : <Map<String, dynamic>>[];
  }

  /// ======================================================
  /// FOOD IMAGES
  /// ======================================================

  List<String> get foodImages {
    return foodItems
        .map((e) => e['imageUrl']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .take(2)
        .toList();
  }

  /// ======================================================
  /// FOOD NAMES
  /// ======================================================

  String get foodNames {
    return foodItems.map((e) => e['name']?.toString() ?? '').join(', ');
  }

  /// ======================================================
  /// TOTAL AMOUNT
  /// ======================================================

  dynamic get totalAmount => orderData['totalAmount'] ?? 0;

  /// ======================================================
  /// CREATED DATE
  /// ======================================================

  dynamic get createdTimestamp =>
      HistoryService.safeToTimestamp(orderData['createdAt']);

  String get dateText => HistoryService.formatDate(createdTimestamp);

  /// ======================================================
  /// ITEM COUNT
  /// ======================================================

  int get itemCount => foodItems.length;
}
