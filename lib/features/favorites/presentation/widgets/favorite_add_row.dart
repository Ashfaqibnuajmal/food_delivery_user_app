import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';

class FavoriteAddRow extends StatelessWidget {
  final String id;
  final Map<String, dynamic> fav;
  final String price;

  const FavoriteAddRow({
    super.key,
    required this.id,
    required this.fav,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(price.isNotEmpty ? " ₹ $price.00" : "", style: mediumBold),

        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final bool inCart = state.cartItems.any(
              (it) => it['id']?.toString() == id.toString(),
            );

            /// IF ALREADY IN CART → SHOW CHECK BUTTON
            if (inCart) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              );
            }

            /// IF NOT IN CART → SHOW ADD BUTTON
            return InkWell(
              onTap: () {
                final cartItems = {
                  'id': id,
                  'name': fav['name'],
                  'price': fav['price'],
                  'prepTimeMinutes': fav['prepTimeMinutes'],
                  'imageUrl': fav['imageUrl'],
                  'calories': fav['calories'],
                  'category': fav['category'],
                  'description': fav['description'],
                  'halfPrice': fav['halfPrice'],
                  'isHalfAvailable': fav['isHalfAvailable'],
                  'isTodayOffer': fav['isTodayOffer'],
                  'isBestSeller': fav['isBestSeller'],
                };

                context.read<CartBloc>().add(AddToCart(cartItems));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Food item successfully added',
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.primaryOrange,
                        ),
                      ],
                    ),
                    backgroundColor: Colors.white,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Text("Add", style: smallBold),
                    SizedBox(width: 4),
                    Icon(Icons.add_circle_rounded, color: Colors.black),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
