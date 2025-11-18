import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/cart/controller/checkout_controller.dart';

class PlaceOrderButton extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double total;
  final CheckoutController controller;

  const PlaceOrderButton({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: AppColors.primaryOrange,
        ),

        // ✅ Your requested code here
        onPressed: () {
          if (!controller.validateLocation()) return;

          controller.placeOrder(
            subtotal: subtotal,
            discount: discount,
            total: total,
          );
        },

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Place Order", style: mediumBold),
            SizedBox(width: 5),
            Icon(Icons.arrow_forward_rounded, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
