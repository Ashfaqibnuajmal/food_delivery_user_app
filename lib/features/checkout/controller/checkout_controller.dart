import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/checkout/cubit/payment/select_payment_cubit.dart';
import 'package:food_user_app/features/checkout/cubit/checkout/checkout_cubit.dart';
import '../cubit/location/location_cubit.dart';
import '../cubit/location/location_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutController {
  final BuildContext context;

  CheckoutController(this.context);

  /// Validate location before placing order
  bool validateLocation() {
    final locationState = context.read<LocationCubit>().state;

    if (locationState is! LocationLoaded &&
        locationState is! ManualAddressSelected) {
      CustomSnackBar.redCustomSnackBar(
        context,
        "Please add your delivery address!",
      );
      return false;
    }
    return true;
  }

  /// Call cubit to place order
  void placeOrder({
    required double subtotal,
    required double discount,
    required double total,
  }) {
    // ✅ Read all required data from their cubits/blocs
    final cartItems = context.read<CartBloc>().state.cartItems;
    final locationState = context.read<LocationCubit>().state;
    final paymentMode = context.read<SelectPaymentCubit>().state;

    context.read<CheckoutCubit>().placeOrder(
      subtotal: subtotal,
      discount: discount,
      total: total,
      cartItems: cartItems,
      locationState: locationState,
      paymentMode: paymentMode,
    );
  }

  /// After order success: clear cart + reset flags
  Future<void> afterOrderSuccess() async {
    context.read<CartBloc>().add(ClearCart());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('coolDrinkBottomSheetShown');
  }
}
