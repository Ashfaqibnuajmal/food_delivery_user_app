class OrderModel {
  String orderId;
  String userId;
  String userName;
  String phoneNumber;
  double subTotal;
  double discount;
  double totalAmount;
  String orderStatus;
  DateTime createdAt;
  List<Map<String, dynamic>> foodItems;
  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.userName,
      required this.phoneNumber,
      required this.subTotal,
      required this.discount,
      required this.totalAmount,
      required this.orderStatus,
      required this.createdAt,
      required this.foodItems});
  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "userId": userId,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "subTotal": subTotal,
      "discount": discount,
      "totalAmount": totalAmount,
      "orderStatus": orderStatus,
      "createdAt": createdAt.toIso8601String(),
      "foodItems": foodItems,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map["orderId"] ?? "",
      userId: map["userId"] ?? "",
      userName: map["userName"] ?? "",
      phoneNumber: map["phoneNumber"] ?? "",
      subTotal: (map["subTotal"] ?? 0).toDouble(),
      discount: (map["discount"] ?? 0).toDouble(),
      totalAmount: (map["totalAmount"] ?? 0).toDouble(),
      orderStatus: map["orderStatus"] ?? "Making",
      createdAt: DateTime.tryParse(map["createdAt"] ?? "") ?? DateTime.now(),
      foodItems: List<Map<String, dynamic>>.from(map["foodItems"] ?? []),
    );
  }
}
