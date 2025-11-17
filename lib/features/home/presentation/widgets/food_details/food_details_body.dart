import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:food_user_app/core/services/rating_service.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/core/widgets/rating_alert_message.dart';
import 'package:food_user_app/features/home/presentation/widgets/food_details/food_header.dart';
import 'package:food_user_app/features/home/presentation/widgets/food_details/food_portion_selector.dart';

class FoodDetailsBody extends StatelessWidget {
  final String foodItemId;
  const FoodDetailsBody({super.key, required this.foodItemId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("FoodItems")
          .doc(foodItemId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("❌ Food details not found"));
        }

        final food = snapshot.data!;
        final data = food.data() as Map<String, dynamic>;

        final image = data['imageUrl'] ?? '';
        final name = data['name'] ?? 'Unknown';
        final prepTime = data['prepTimeMinutes'] ?? 0;
        final calories = data['calories'] ?? 0;
        final price = data['price'] ?? 0;
        final halfPrice = data['halfPrice'] ?? 0;
        final description = data['description'] ?? '';
        final isHalfAvailable = data['isHalfAvailable'] ?? false;

        Map<String, dynamic> buildFavMap() {
          return {
            'id': foodItemId.toString(),
            'name': name.toString(),
            'price': price,
            'halfPrice': halfPrice,
            'imageUrl': image.toString(),
            'prepTimeMinutes': prepTime,
            'isHalfAvailable': isHalfAvailable,
          };
        }

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                FoodHeader(
                  image: image,
                  foodItemId: foodItemId,
                  buildFavMap: buildFavMap,
                ),
                const Gap(30),
                Text(
                  name.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),

                // ⭐ Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => showFoodRatingDialog(context, food.id),
                      child: StreamBuilder<Map<String, dynamic>>(
                        stream: RatingServices.getRatingData(food.id),
                        builder: (context, ratingSnapshot) {
                          if (ratingSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text("..."),
                              ],
                            );
                          }

                          if (!ratingSnapshot.hasData ||
                              ratingSnapshot.data!.isEmpty) {
                            return const Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text("0.0"),
                              ],
                            );
                          }

                          final ratingData = ratingSnapshot.data!;
                          final avg = (ratingData['averageRating'] ?? 0.0)
                              .toDouble();

                          return Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.primaryOrange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                avg.toStringAsFixed(1),
                                style: ratingTextStyle,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 15,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Text('$prepTime min', style: ratingTextStyle),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 15,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Text('$calories Ka', style: ratingTextStyle),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 📝 Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    description.toString(),
                    textAlign: TextAlign.center,
                    style: greySmallTextStyle,
                  ),
                ),

                const SizedBox(height: 30),

                FoodPortionSelector(
                  isHalfAvailable: isHalfAvailable,
                  image: image,
                  price: price,
                  halfPrice: halfPrice,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}
