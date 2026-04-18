import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/food_container.dart';
import 'package:food_user_app/features/food_details/screen/food_details.dart';
import 'package:food_user_app/features/best_compo/widgets/add_to_cart_button.dart';
import 'package:food_user_app/core/widgets/favorite_button.dart';
import 'package:food_user_app/features/search/presentation/widgets/search_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final id = food['id'];

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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [SearchRatingBar(id: id)],
                  ),

                  // 🔹 Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        food["imageUrl"] ?? "",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,

                        // 🟢 Add shimmer while loading
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // ✅ image fully loaded
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

                        // 🟠 Fallback if image fails to load
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

                  // 🔹 Name
                  Text(
                    food["name"] ?? "",
                    style: mediumBold,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // 🔹 Price + Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("₹${food["price"]}.00", style: mediumBold),
                      AddToCartButton(id: id, food: food),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Favorite
          FavoriteButton(id: id, food: food),
        ],
      ),
    );
  }
}
