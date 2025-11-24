import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/food_image.dart';
import 'package:food_user_app/features/cart/controller/cart_controller.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart/cart_actions.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart/cart_item_info.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart/cart_price_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Orders"),
      body: Column(
        children: [
          // 🛒 CART LIST
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final cartItems = CartController.getCartItems(context);

                if (cartItems.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_rounded,
                          size: 70,
                          color: AppColors.primaryOrange,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No Order Yet!",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "When you add foods, they’ll\n appear here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cart = cartItems[index];

                    final id = cart['id']?.toString() ?? '';
                    final name = (cart['name'] ?? '') as String;
                    final imageUrl =
                        (cart['imageUrl'] ?? cart['image'] ?? '') as String;

                    final double price =
                        double.tryParse(cart['price']?.toString() ?? '0') ?? 0;

                    final double halfPrice =
                        double.tryParse(cart['halfPrice']?.toString() ?? '0') ??
                        0;

                    final bool isHalf = cart['isHalf'] == true;
                    final bool isTodayOffer = cart['isTodayOffer'] == true;

                    final double actualPrice = isHalf ? halfPrice : price;
                    final double finalPrice = isTodayOffer
                        ? (actualPrice * 0.5)
                        : actualPrice;

                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FoodImage(imageUrl: imageUrl),
                            const SizedBox(width: 10),
                            CartItemInfo(
                              id: id,
                              name: name,
                              isHalf: isHalf,
                              finalPrice: finalPrice,
                              isTodayOffer: isTodayOffer,
                            ),
                            CartItemActions(id: id),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final cartitems = CartController.getCartItems(context);
              if (cartitems.isEmpty) {
                return SizedBox.shrink();
              }
              final totals = CartController.calculateTotals(context);
              return Padding(
                padding: const EdgeInsets.all(16),
                child: CartPriceSummary(
                  subtotal: totals['subtotal']!,
                  discountTotal: totals['discount']!,
                  deliveryFee: totals['delivery']!,
                  total: totals['total']!,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
