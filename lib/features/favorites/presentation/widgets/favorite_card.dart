import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/favorites/presentation/widgets/favorite_add_row.dart';
import 'package:food_user_app/core/widgets/food_image.dart';
import 'package:food_user_app/features/favorites/presentation/widgets/favorite_rating.dart';
import 'package:food_user_app/features/favorites/presentation/widgets/favorite_remove_icon.dart';

class FavoriteCard extends StatelessWidget {
  final Map<String, dynamic> fav;
  final String id;
  final String imageUrl;
  final String name;
  final String prepTime;
  final String price;

  const FavoriteCard({
    super.key,
    required this.fav,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.prepTime,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primaryOrange, width: 0.5),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FoodImage(imageUrl: imageUrl),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: mediumBold),

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
                            prepTime.isNotEmpty ? "$prepTime min" : "N/A",
                            style: prepkcalTextStyle,
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      FavoriteRating(id: id),
                      FavoriteAddRow(id: fav['id'], fav: fav, price: price),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),

          RemoveFavoriteButton(id: id),
        ],
      ),
    );
  }
}
