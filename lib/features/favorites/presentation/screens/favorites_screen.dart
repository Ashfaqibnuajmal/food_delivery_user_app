import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_event.dart';
import 'package:food_user_app/core/blocs/search/search_state.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar_action.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_event.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_state.dart';
import 'package:food_user_app/features/home/presentation/screens/search_screen.dart';
import 'package:shimmer/shimmer.dart';

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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          icon: const Icon(Icons.search_rounded, color: AppColors.black),
        ),
        actions: const [CustomAppBarActions(showChatBot: false)],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 50,
            width: 340,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.primaryOrange.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      context.read<FoodSearchBloc>().add(UpdateQuery(value));
                    },
                  ),
                ),
                BlocBuilder<FoodSearchBloc, FoodSearchState>(
                  builder: (context, state) {
                    if (state.query.isEmpty) {
                      return const SizedBox(width: 0);
                    }
                    return Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE0B2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            context.read<FoodSearchBloc>().add(
                              const UpdateQuery(""),
                            );
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.primaryOrange,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                // Get the current search query from FoodSearchBloc
                final query = context.select(
                  (FoodSearchBloc bloc) => bloc.state.query.toLowerCase(),
                );

                final favorites = state.favorites.where((fav) {
                  final name = (fav['name'] ?? '').toString().toLowerCase();
                  return name.contains(query);
                }).toList();

                if (favorites.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 40,
                          color: AppColors.primaryOrange,
                        ),
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

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 30,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final fav = favorites[index];
                    final id = fav['id']?.toString() ?? '';
                    final imageUrl =
                        (fav['imageUrl'] ?? fav['image'] ?? '') as String;
                    final name = (fav['name'] ?? '') as String;
                    final price = fav['price'] != null
                        ? fav['price'].toString()
                        : '';

                    final prepTime = fav['prepTimeMinutes'] != null
                        ? fav['prepTimeMinutes'].toString()
                        : '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Stack(
                        children: [
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: AppColors.primaryOrange,
                                width: 0.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      // show network image if valid string url, else show a placeholder asset
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill,

                                                // 🟢 Show shimmer while image is loading
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          width: 80,
                                                          height: 80,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    },

                                                // 🟠 If image fails to load
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          width: 60,
                                                          height: 60,
                                                          color:
                                                              Colors.grey[200],
                                                          child: const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                              )
                                            // ⚪ If no image URL at all
                                            : Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.fastfood,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                      ),

                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                                  prepTime.isNotEmpty
                                                      ? "$prepTime min"
                                                      : "N/A",
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            const Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color:
                                                      AppColors.primaryOrange,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  ' 4.5',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  price.isNotEmpty
                                                      ? " ₹ $price.00"
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                BlocBuilder<
                                                  CartBloc,
                                                  CartState
                                                >(
                                                  builder: (context, state) {
                                                    return InkWell(
                                                      onTap: () {
                                                        final cartItems = {
                                                          'id': id,
                                                          'name': fav['name'],
                                                          'price': fav['price'],
                                                          'prepTimeMinutes':
                                                              fav['prepTimeMinutes'],
                                                          'imageUrl':
                                                              fav['imageUrl'],
                                                          'calories':
                                                              fav['calories'],
                                                          'category':
                                                              fav['category'],
                                                          'description':
                                                              fav['description'],
                                                          'halfPrice':
                                                              fav['halfPrice'],
                                                          "isHalfAvailable":
                                                              fav['isHalfAvailable'],
                                                          'isTodayOffer':
                                                              fav['isTodayOffer'],
                                                          'isBestSeller':
                                                              fav['isBestSeller'],
                                                        };
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              AddToCart(
                                                                cartItems,
                                                              ),
                                                            );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: const Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Food item successfully added',
                                                                  style: TextStyle(
                                                                    color: AppColors
                                                                        .primaryOrange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .check_circle_outline,
                                                                  color: AppColors
                                                                      .primaryOrange,
                                                                ),
                                                              ],
                                                            ),
                                                            backgroundColor:
                                                                Colors.white,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            duration:
                                                                const Duration(
                                                                  seconds: 2,
                                                                ),
                                                          ),
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
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 2,
                                                              offset: Offset(
                                                                1,
                                                                2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: const Row(
                                                          children: [
                                                            Text(
                                                              "Add",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(width: 4),
                                                            Icon(
                                                              Icons
                                                                  .add_circle_rounded,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
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
                                        context.read<FavoriteBloc>().add(
                                          RemoveFromFavorite(id),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Remove from favorites!',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.white,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets
                                          .zero, // centers the icon properly
                                      constraints:
                                          const BoxConstraints(), // removes default extra padding
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
