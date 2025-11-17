import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_event.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_state.dart';

class FavoriteButton extends StatelessWidget {
  final String id;
  final Map<String, dynamic> food;

  const FavoriteButton({super.key, required this.id, required this.food});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favState) {
        final isFav = favState.favorites.any((item) => item['id'] == id);
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
                  context.read<FavoriteBloc>().add(RemoveFromFavorite(id));
                } else {
                  final favItems = {
                    'id': id,
                    'name': food['name'],
                    'price': food['price'],
                    'prepTimeMinutes': food['prepTimeMinutes'],
                    'imageUrl': food['imageUrl'],
                  };
                  context.read<FavoriteBloc>().add(AddToFavorite(favItems));
                }
              },
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              padding: EdgeInsets.zero, // centers icon properly
              constraints: const BoxConstraints(), // removes default padding
            ),
          ),
        );
      },
    );
  }
}
