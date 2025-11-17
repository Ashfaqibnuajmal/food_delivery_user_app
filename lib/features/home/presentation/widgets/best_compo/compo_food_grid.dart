import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_event.dart';
import 'package:food_user_app/core/blocs/search/search_state.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/food_container.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/home/presentation/screens/food_details.dart';
import 'package:food_user_app/features/home/presentation/widgets/best_compo/add_to_cart_button.dart';
import 'package:food_user_app/core/widgets/favorite_button.dart';
import 'package:food_user_app/features/home/presentation/widgets/best_compo/compo_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class CompoFoodGrid extends StatelessWidget {
  const CompoFoodGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("FoodItems")
            .where("isCompo", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong!",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Icon(
                    Icons.search_off_rounded,
                    size: 50,
                    color: AppColors.primaryOrange,
                  ),
                  Text("No Food Items Found!", style: emptyTextStyle),
                ],
              ),
            );
          }

          final items = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<FoodSearchBloc>().add(SetFoodItems(items));
          });

          return BlocBuilder<FoodSearchBloc, FoodSearchState>(
            builder: (context, state) {
              final foodItems = state.filteredItems;

              if (foodItems.isEmpty) {
                return const Center(
                  child: Text("No Compo Items Found", style: emptyTextStyle),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: foodItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final food = foodItems[index];
                  final id = food['id'] ?? '';

                  return _CompoFoodCard(food: food, id: id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _CompoFoodCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final String id;

  const _CompoFoodCard({required this.food, required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodDetails(foodItemId: id)),
        );
      },
      child: Stack(
        children: [
          CustomStyledContainer(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            food["imageUrl"] ?? "",
                            height: 90,
                            width: 90,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food["name"] ?? "",
                        style: smallBold,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${food["prepTimeMinutes"] ?? 0} min",
                            style: prepkcalTextStyle,
                          ),
                          Container(
                            height: 12,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          Text(
                            "${food["calories"] ?? 0} kcal",
                            style: prepkcalTextStyle,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₹${food["price"] ?? 0}.00", style: mediumBold),
                          AddToCartButton(id: id, food: food),
                        ],
                      ),
                    ],
                  ),
                  CompoRatingBar(id: id),
                ],
              ),
            ),
          ),
          FavoriteButton(id: food['id'], food: food),
        ],
      ),
    );
  }
}
