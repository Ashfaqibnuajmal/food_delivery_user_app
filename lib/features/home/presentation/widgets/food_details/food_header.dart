import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_event.dart';
import 'package:shimmer/shimmer.dart';

class FoodHeader extends StatelessWidget {
  final String image;
  final String foodItemId;
  final Map<String, dynamic> Function() buildFavMap;

  const FoodHeader({
    super.key,
    required this.image,
    required this.foodItemId,
    required this.buildFavMap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🟧 Orange Background
        Container(
          height: 350,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),

        // 🟨 Top Row (Back + Favorite)
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔙 Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              // ❤️ Favorite Button
              BlocBuilder<FavoriteBloc, dynamic>(
                builder: (context, favState) {
                  final favList = (favState is Map || favState == null)
                      ? <Map<String, dynamic>>[]
                      : (favState.favorites ?? <Map<String, dynamic>>[]);

                  List<Map<String, dynamic>> favorites =
                      <Map<String, dynamic>>[];
                  try {
                    favorites = List<Map<String, dynamic>>.from(favList);
                  } catch (_) {}

                  final bool isFav = favorites.any(
                    (item) => item['id']?.toString() == foodItemId.toString(),
                  );

                  return IconButton(
                    onPressed: () {
                      final bloc = context.read<FavoriteBloc>();
                      if (isFav) {
                        bloc.add(RemoveFromFavorite(foodItemId.toString()));
                      } else {
                        final favMap = buildFavMap();
                        bloc.add(AddToFavorite(favMap));
                      }
                    },
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // 🖼️ Food Image
        Positioned(
          bottom: -10,
          left: 40,
          right: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.fill,
                    height: 300,
                    width: double.infinity,

                    // 🟢 Shimmer while loading image
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      );
                    },

                    // 🟠 Fallback if image fails
                    errorBuilder: (context, error, stackTrace) =>
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 300,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
