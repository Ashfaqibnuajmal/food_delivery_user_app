import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/cubit/cart/cart_quantity_cubit.dart';

class CartController {
  /// Get all cart items from Bloc
  static List<Map<String, dynamic>> getCartItems(BuildContext context) {
    return context.read<CartBloc>().state.cartItems;
  }

  /// Get item quantity
  static int getQuantity(BuildContext context, String id) {
    return context.read<CartQuantityCubit>().state[id] ?? 1;
  }

  /// Calculate totals: subtotal, discount, total
  static Map<String, double> calculateTotals(BuildContext context) {
    final cartItems = getCartItems(context);

    double subtotal = 0.0;
    double totalDiscount = 0.0;

    for (var item in cartItems) {
      final id = item['id']?.toString() ?? '';
      final bool isHalf = item['isHalf'] == true;
      final bool isTodayOffer = item['isTodayOffer'] == true;
      final quantity = getQuantity(context, id);

      final double price =
          double.tryParse(
            isHalf
                ? (item['halfPrice'] ?? '0').toString()
                : (item['price'] ?? '0').toString(),
          ) ??
          0;

      double itemDiscount = isTodayOffer ? (price * 0.5) : 0;
      double finalPrice = price - itemDiscount;

      subtotal += finalPrice * quantity;
      totalDiscount += itemDiscount * quantity;
    }

    const deliveryFee = 30.0;

    return {
      'subtotal': subtotal,
      'discount': totalDiscount,
      'delivery': deliveryFee,
      'total': subtotal + deliveryFee,
    };
  }
}
