import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/search_bar.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_state.dart';
import 'package:food_user_app/features/favorites/controller/favorite_cotroller.dart';
import 'package:food_user_app/features/favorites/presentation/widgets/favorite_card.dart';
import '../../../../core/blocs/search/search_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    context.read<FoodSearchBloc>().stream.listen((state) {
      if (_controller.text != state.query) {
        _controller.text = state.query;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Favorites"),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: SearchBarController(controller: _controller),
          ),

          /// Favorites List
          Expanded(
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                final favorites = FavoritesController.filterFavorites(
                  state: state,
                  context: context,
                );

                if (favorites.isEmpty) {
                  return FavoritesController.emptyFavorites();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 30,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final fav = favorites[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: FavoriteCard(
                        fav: fav,
                        id: fav['id'],
                        imageUrl: fav['imageUrl'],
                        name: fav['name'],
                        prepTime: fav['prepTimeMinutes'].toString(),
                        price: fav['price'].toString(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
