import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/category/food_category_filter_cubit.dart';
import 'package:food_user_app/core/services/rating_service.dart';
import 'package:food_user_app/core/theme/text_style.dart';
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

class FoodItemsList extends StatelessWidget {
  const FoodItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("FoodItems").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Food Items Found", style: emptyTextStyle),
          );
        }

        final allFoodItems = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        return BlocBuilder<FoodCategoryFilterCubit, String?>(
          builder: (context, selectedCategory) {
            final filteredItems = selectedCategory == null
                ? allFoodItems
                : allFoodItems
                      .where(
                        (item) =>
                            item['category'].toString().toLowerCase() ==
                            selectedCategory.toLowerCase(),
                      )
                      .toList();
            if (filteredItems.isEmpty) {
              return const Center(
                child: Text("No items found in this category"),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final food = filteredItems[index];
                final id = food['id'];
                final bool isBestSeller = food["isBestSeller"] == true;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Stack(
                    children: [
                      // Main Container
                      InkWell(
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
                            Container(
                              height: 124,
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.primaryOrange.withOpacity(
                                    0.3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryOrange.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(1, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // 🍽️ Image Section with Shimmer Placeholder
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      food["imageUrl"] ?? "",
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                      // Show shimmer while image loads
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child; // ✅ Image loaded
                                            }
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 80,
                                                width: 80,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                      // Fallback if image fails to load
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  // Details Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                food["name"] ?? "",
                                                overflow: TextOverflow.ellipsis,
                                                style: mediumBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.timer_outlined,
                                              size: 15,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${food["prepTimeMinutes"]} min",
                                              style: prepkcalTextStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        StreamBuilder<Map<String, dynamic>>(
                                          stream: RatingServices.getRatingData(
                                            id,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 14,
                                                    color:
                                                        AppColors.primaryOrange,
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
                                                    color:
                                                        AppColors.primaryOrange,
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    "0.0",
                                                    style: ratingTextStyle,
                                                  ),
                                                ],
                                              );
                                            }

                                            final data = snapshot.data!;
                                            final avg =
                                                (data['averageRating'] ?? 0.0)
                                                    .toDouble();

                                            return Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color:
                                                      AppColors.primaryOrange,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              " ₹ ${food["price"]}.00",
                                              style: mediumBold,
                                            ),
                                            BlocBuilder<CartBloc, CartState>(
                                              builder: (context, state) {
                                                final bool inCart = state
                                                    .cartItems
                                                    .any(
                                                      (it) =>
                                                          it['id']
                                                              ?.toString() ==
                                                          id.toString(),
                                                    );
                                                if (inCart) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 2,
                                                          offset: Offset(1, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 20,
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
                                                      'imageUrl':
                                                          food['imageUrl'],
                                                      'calories':
                                                          food['calories'],
                                                      'category':
                                                          food['category'],
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
                                                    context
                                                        .read<CartBloc>()
                                                        .add(
                                                          AddToCart(cartItems),
                                                        );
                                                    CustomSnackBar.showSuccess(
                                                      context,
                                                      message:
                                                          'Food item successfully added',
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryOrange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
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
                                                        Text(
                                                          "Add",
                                                          style: smallBold,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Icon(
                                                          Icons
                                                              .add_circle_rounded,
                                                          color: Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<FavoriteBloc, FavoriteState>(
                              builder: (context, favState) {
                                final isFav = favState.favorites.any(
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
                                        topRight: Radius.circular(12),
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
                                            "imageUrl": food['imageUrl'],
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
                      if (isBestSeller)
                        Positioned(
                          top: -10,
                          left: 4,
                          child: Image.asset(
                            "assets/best-seller.png",
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
