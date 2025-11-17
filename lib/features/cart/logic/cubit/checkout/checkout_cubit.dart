import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_user_app/features/cart/data/model/order_model.dart';
import 'package:food_user_app/features/cart/data/services/cart_services.dart';
import 'package:food_user_app/features/cart/data/services/order_service.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  Future<void> placeOrder({
    required double subtotal,
    required double discount,
    required double total,
  }) async {
    emit(CheckoutLoading());
    try {
      // ✅ 1. Get cart items and current user
      final cartItems = await CartServices.getCartItems();
      final user = FirebaseAuth.instance.currentUser;

      // ✅ 2. Fetch user details from Firestore (Users collection)
      String name = "Guest User";
      String phone = "9876543210";

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          name = data['name'] ?? user.displayName ?? "Guest User";
          phone = data['phone'] ?? user.phoneNumber ?? "9876543210";
        } else {
          // fallback if no Firestore record
          name = user.displayName ?? user.email ?? "Guest User";
          phone = user.phoneNumber ?? "9876543210";
        }
      }

      // ✅ 3. Build order model
      final orderModel = OrderModel(
        orderId: FirebaseFirestore.instance.collection('Orders').doc().id,
        userId: user?.uid ?? "guest_123",
        userName: name,
        phoneNumber: phone,
        foodItems: cartItems,
        subTotal: subtotal,
        discount: discount,
        totalAmount: total,
        orderStatus: 'Making',
        createdAt: DateTime.now(),
      );

      // ✅ 4. Save to Firestore
      await OrderService().placeOrder(orderModel);

      // ✅ 5. Clear cart
      await CartServices.clearFirestoreCart();

      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutFailure(e.toString()));
    }
  }
}
