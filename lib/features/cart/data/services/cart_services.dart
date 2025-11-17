import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';

class CartServices {
  /// ✅ Add multiple items to cart
  static void addMultipleToCart(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    if (items.isEmpty) return;

    final cartBloc = context.read<CartBloc>();

    for (var item in items) {
      cartBloc.add(AddToCart(item));
    }
    CustomSnackBar.showSuccess(context, message: "Added to cart successfully");
  }

  /// ✅ Clear all items from cart
  static void clearCart(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    cartBloc.add(ClearCart());
  }

  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Cart")
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> clearFirestoreCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final cartRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Cart");
    final batch = FirebaseFirestore.instance.batch();
    final items = await cartRef.get();
    for (var doc in items.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
