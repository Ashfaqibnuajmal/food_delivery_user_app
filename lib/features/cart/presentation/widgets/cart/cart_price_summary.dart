import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/presentation/screens/checkout_screen.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart/drinks_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPriceSummary extends StatelessWidget {
  final double subtotal;
  final double discountTotal;
  final double deliveryFee;
  final double total;

  const CartPriceSummary({
    super.key,
    required this.subtotal,
    required this.discountTotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _priceRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
        _priceRow("Discount", "₹${discountTotal.toStringAsFixed(2)}"),
        _priceRow("Delivery fee", "₹${deliveryFee.toStringAsFixed(2)}"),

        const Divider(thickness: 1),

        _priceRow(
          "Total",
          "₹${total.toStringAsFixed(2)}",
          isBold: true,
          fontSize: 20,
        ),

        const Divider(thickness: 1),
        const SizedBox(height: 15),

        // 🟧 Checkout Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: AppColors.primaryOrange,
            ),
            onPressed: () async {
              final cartItems = context.read<CartBloc>().state.cartItems;

              final hasCoolDrink = cartItems.any(
                (item) =>
                    (item['category']?.toString().toLowerCase() ?? '') ==
                    'cool drinks',
              );

              final prefs = await SharedPreferences.getInstance();
              final bottomSheetShown =
                  prefs.getBool('coolDrinkBottomSheetShown') ?? false;

              if (!bottomSheetShown && !hasCoolDrink) {
                await prefs.setBool('coolDrinkBottomSheetShown', true);

                await showModalBottomSheet(
                  // ignore: use_build_context_synchronously
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CoolDrinksBottomSheet(),
                );
                return;
              }

              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    subtotal: subtotal,
                    discount: discountTotal,
                    deliveryFee: deliveryFee,
                    total: total,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Go to Checkout", style: mediumBold),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_rounded, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Reused price row
  Widget _priceRow(
    String title,
    String value, {
    bool isBold = false,
    double fontSize = 15,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
