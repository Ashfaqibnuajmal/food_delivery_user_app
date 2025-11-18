import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_state.dart';
import '../../../../core/blocs/search/search_bloc.dart';

class FavoritesController {
  /// Returns filtered favorites using the search query
  static List<Map<String, dynamic>> filterFavorites({
    required FavoriteState state,
    required BuildContext context,
  }) {
    final query = context.select(
      (FoodSearchBloc bloc) => bloc.state.query.toLowerCase(),
    );

    return state.favorites.where((fav) {
      final name = (fav['name'] ?? '').toString().toLowerCase();
      return name.contains(query);
    }).toList();
  }

  /// Empty favorites widget
  static Widget emptyFavorites() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 40, color: Colors.orange),
          SizedBox(height: 10),
          Text(
            "No Favorites Items!",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "You don't have any favorites items.\nGo to home and add store",
            style: TextStyle(color: Colors.black45, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
