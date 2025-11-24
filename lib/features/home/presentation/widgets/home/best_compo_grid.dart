import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/services/rating_service.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/food_container.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_event.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_state.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/home/presentation/screens/food_details.dart';
import 'package:shimmer/shimmer.dart';

class BestCompoCardGrid extends StatelessWidget {
  const BestCompoCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("FoodItems")
            .where("isCompo", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Compo items found!"));
          }

          final foodItems = snapshot.data!.docs;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodItems.length > 4 ? 4 : foodItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.74,
            ),
            itemBuilder: (context, index) {
              final food = foodItems[index].data()! as Map<String, dynamic>;
              final doc = foodItems[index];
              final id = doc.id;

              return AspectRatio(
                aspectRatio: 0.8,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetails(foodItemId: id),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      CustomStyledContainer(
                        padding: const EdgeInsets.all(6),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 25),
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      food['imageUrl'] ?? "",
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  food["name"] ?? "",
                                  style: smallBold,
                                  textAlign: TextAlign.center,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            "₹${food["price"]}.00",
                                            style: mediumBold,
                                          ),
                                        ),
                                        BlocBuilder<CartBloc, CartState>(
                                          builder: (context, cartState) {
                                            final bool inCart = cartState
                                                .cartItems
                                                .any(
                                                  (it) =>
                                                      it['id'].toString() ==
                                                      id.toString(),
                                                );
                                            if (inCart) {
                                              return Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              );
                                            }
                                            return InkWell(
                                              onTap: () {
                                                final cartItems = {
                                                  'id': id,
                                                  'name': food['name'],
                                                  'price': food['price'],
                                                  'prepTimeMinutes':
                                                      food['prepTimeMinutes'],
                                                  'imageUrl': food['imageUrl'],
                                                  'calories': food['calories'],
                                                  'category': food['category'],
                                                  'description':
                                                      food['description'],
                                                  'halfPrice':
                                                      food['halfPrice'],
                                                  "isHalfAvailable":
                                                      food['isHalfAvailable'],
                                                  'isTodayOffer':
                                                      food['isTodayOffer'],
                                                  'isBestSeller':
                                                      food['isBestSeller'],
                                                };
                                                context.read<CartBloc>().add(
                                                  AddToCart(cartItems),
                                                );
                                                CustomSnackBar.showSuccess(
                                                  context,
                                                  message:
                                                      "Food Items successfully added",
                                                );
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: const BoxDecoration(
                                                  color:
                                                      AppColors.primaryOrange,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              left: -3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: StreamBuilder<Map<String, dynamic>>(
                                  stream: RatingServices.getRatingData(id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: AppColors.primaryOrange,
                                          ),
                                          SizedBox(width: 3),
                                          Text("..."),
                                        ],
                                      );
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: AppColors.primaryOrange,
                                          ),
                                          SizedBox(width: 3),
                                          Text("0.0", style: ratingTextStyle),
                                        ],
                                      );
                                    }
                                    final data = snapshot.data!;
                                    final avg = (data['averageRating'] ?? 0.0)
                                        .toDouble();
                                    return Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: AppColors.primaryOrange,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          avg.toStringAsFixed(1),
                                          style: ratingTextStyle,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, favState) {
                          final bool isFav = favState.favorites.any(
                            (item) => item['id'] == id,
                          );
                          return Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryOrange,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (isFav) {
                                    context.read<FavoriteBloc>().add(
                                      RemoveFromFavorite(id),
                                    );
                                  } else {
                                    final favItems = {
                                      'id': id,
                                      'name': food['name'],
                                      'price': food['price'],
                                      'prepTimeMinutes':
                                          food['prepTimeMinutes'],
                                      'imageUrl': food['imageUrl'],
                                    };
                                    context.read<FavoriteBloc>().add(
                                      AddToFavorite(favItems),
                                    );
                                  }
                                },
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets
                                    .zero, // centers the icon properly
                                constraints:
                                    const BoxConstraints(), // removes default extra padding
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
