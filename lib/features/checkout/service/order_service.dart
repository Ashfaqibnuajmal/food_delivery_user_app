import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/features/cart/data/model/order_model.dart';
import 'package:http/http.dart' as http;

class OrderService extends ChangeNotifier {
  final orderCollection = FirebaseFirestore.instance.collection("Orders");

  // 🔹 Cloudinary details
  static const cloudName = "dsuwmcmw4";
  static const cloudPresent = "flutter_uploads";
  static const cloudApiKey = "837695524881733";
  static const cloudApiSecretKey = "BMxWLGuxc0qhl2QAlwmLsXXS3k0";

  /// 🔹 Upload an image to Cloudinary (used for food images if needed)
  Future<String?> uploadImageToCloudinary(Uint8List imageBytes) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = cloudPresent
        ..files.add(
          http.MultipartFile.fromBytes(
            "file",
            imageBytes,
            filename: "order_item_image",
          ),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final imageUrl = jsonDecode(res.body)["secure_url"];
        log("Image uploaded successfully: $imageUrl");
        return imageUrl;
      } else {
        log("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      log("Error uploading image: $e");
    }
    return null;
  }

  /// 🔹 Place a new order in Firestore
  Future<void> placeOrder(OrderModel orderModel) async {
    try {
      final docRef = orderCollection.doc(orderModel.orderId);
      await docRef.set(orderModel.toMap());
      log("✅ Order placed successfully: ${orderModel.orderId}");
    } catch (e) {
      log("❌ Error placing order: $e");
      rethrow;
    }
  }

  /// 🔹 Fetch all orders of current user
  Stream<List<OrderModel>> fetchUserOrders(String userId) {
    return orderCollection
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
