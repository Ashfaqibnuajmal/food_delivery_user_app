import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';

class FoodDetailsAddToCart extends StatelessWidget {
  final String foodItemId;
  final String name;
  final double price;
  final double halfPrice;
  final int prepTime;
  final String imageUrl;
  final bool isHalfSelected;
  final bool isHalfAvailable;
  final bool isTodayOffer;

  const FoodDetailsAddToCart({
    super.key,
    required this.foodItemId,
    required this.name,
    required this.price,
    required this.halfPrice,
    required this.prepTime,
    required this.imageUrl,
    required this.isHalfSelected,
    required this.isHalfAvailable,
    required this.isTodayOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final bool inCart = cartState.cartItems.any(
              (it) => it['id']?.toString() == foodItemId.toString(),
            );

            return ElevatedButton(
              onPressed: inCart
                  ? null
                  : () {
                      final cartItem = {
                        'id': foodItemId,
                        'name': name,
                        'price': isHalfSelected ? halfPrice : price,
                        'prepTimeMinutes': prepTime,
                        'imageUrl': imageUrl,
                        'isHalf': isHalfSelected,
                        'halfPrice': halfPrice,
                        'isHalfAvailable': isHalfAvailable,
                        'isTodayOffer': isTodayOffer,
                        'quantity': 1,
                      };

                      context.read<CartBloc>().add(AddToCart(cartItem));
                      CustomSnackBar.showSuccess(
                        context,
                        message: "Added to cart successfully",
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.white,
              ),
              child: Text(
                inCart ? "Added" : "Add to cart",
                style: mediumBold.copyWith(color: AppColors.black),
              ),
            );
          },
        ),
      ),
    );
  }
}
