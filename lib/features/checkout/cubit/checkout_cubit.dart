import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_user_app/core/enum/payment_mode.dart';
import 'package:food_user_app/features/cart/data/model/order_model.dart';
import 'package:food_user_app/features/cart/data/services/cart_services.dart';
import 'package:food_user_app/features/checkout/service/order_service.dart';
import 'package:food_user_app/features/address/cubit/location/location_state.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  Future<void> placeOrder({
    required double subtotal,
    required double discount,
    required double total,
    required List<Map<String, dynamic>> cartItems,
    required LocationState locationState,
    required PaymentMode paymentMode,
  }) async {
    emit(CheckoutLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;

      // ✅ Fetch user details
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
          name = user.displayName ?? user.email ?? "Guest User";
          phone = user.phoneNumber ?? "9876543210";
        }
      }

      // ✅ Resolve delivery address from location state
      String deliveryAddress = "";
      if (locationState is LocationLoaded) {
        deliveryAddress = locationState.address;
      } else if (locationState is ManualAddressSelected) {
        deliveryAddress = "${locationState.label} - ${locationState.address}";
      }

      // ✅ Resolve payment method string
      String paymentMethod = paymentMode == PaymentMode.cod
          ? "Cash on Delivery"
          : "Razorpay";

      // ✅ Build order model using cart items from CartBloc state
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
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
      );

      // ✅ Save to Firestore
      await OrderService().placeOrder(orderModel);

      // ✅ Clear Firestore cart
      await CartServices.clearFirestoreCart();

      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutFailure(e.toString()));
    }
  }
}
