import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/cubit/checkout/checkout_cubit.dart';
import 'package:food_user_app/features/cart/logic/cubit/location/location_cubit.dart';
import 'package:food_user_app/features/cart/logic/cubit/location/location_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutController {
  final BuildContext context;

  CheckoutController(this.context);

  /// Validate location before placing order
  bool validateLocation() {
    final locationState = context.read<LocationCubit>().state;

    if (locationState is! LocationLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please add your current location!",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
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
    context.read<CheckoutCubit>().placeOrder(
      subtotal: subtotal,
      discount: discount,
      total: total,
    );
  }

  /// After order success: clear cart + reset flags
  Future<void> afterOrderSuccess() async {
    context.read<CartBloc>().add(ClearCart());

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('coolDrinkBottomSheetShown');
  }
}
