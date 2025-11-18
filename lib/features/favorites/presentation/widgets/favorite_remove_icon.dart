import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_event.dart';
import '../../../../core/theme/app_color.dart';

class RemoveFavoriteButton extends StatelessWidget {
  final String id;

  const RemoveFavoriteButton({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(10),
          ),
        ),
        child: IconButton(
          onPressed: () {
            context.read<FavoriteBloc>().add(RemoveFromFavorite(id));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remove from favorites!',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.check_circle_outline, color: Colors.red),
                  ],
                ),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.favorite, color: Colors.white),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}
