import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';

class AddToCartButton extends StatelessWidget {
  final String id;
  final Map<String, dynamic> food;

  const AddToCartButton({super.key, required this.id, required this.food});

  void _showSnackBar(BuildContext context) {
    CustomSnackBar.showSuccess(
      context,
      message: "Food Item added successfully",
    );
  }

  void _addToCart(BuildContext context) {
    final cartItems = {
      'id': id,
      'name': food['name'],
      'price': food['price'],
      'prepTimeMinutes': food['prepTimeMinutes'],
      'imageUrl': food['imageUrl'],
      'calories': food['calories'],
      'category': food['category'],
      'description': food['description'],
      'halfPrice': food['halfPrice'],
      "isHalfAvailable": food['isHalfAvailable'],
      'isTodayOffer': food['isTodayOffer'],
      'isBestSeller': food['isBestSeller'],
    };

    context.read<CartBloc>().add(AddToCart(cartItems));
    _showSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final bool inCart = state.cartItems.any(
          (it) => it['id']?.toString() == id.toString(),
        );
        if (inCart) {
          return Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          );
        }
        return InkWell(
          onTap: () => _addToCart(context),
          child: Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        );
      },
    );
  }
}
