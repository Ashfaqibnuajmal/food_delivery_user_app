import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/category/food_category_filter_cubit.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_bloc.dart';
import 'package:food_user_app/features/favorites/bloc/favorite_state.dart';
import 'package:food_user_app/features/search/logic/bloc/search_bloc.dart';
import 'package:food_user_app/features/search/logic/bloc/search_event.dart';
import 'package:food_user_app/features/search/logic/bloc/search_state.dart';
import 'package:food_user_app/features/search/logic/cubit/search_filter_cubit.dart';
import 'package:food_user_app/features/search/logic/cubit/search_filter_state.dart';
import 'package:food_user_app/features/search/presentation/widgets/search_food_card.dart';

class SearchFoodGrid extends StatelessWidget {
  final String collection;

  const SearchFoodGrid({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collection).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Food Items Found"));
          }

          // 🔹 Convert Firestore docs to list
          final items = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

          // 🔹 Send items to FoodSearchBloc
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<FoodSearchBloc>().add(SetFoodItems(items));
          });

          return BlocBuilder<FoodSearchBloc, FoodSearchState>(
            builder: (context, searchState) {
              return BlocBuilder<FoodCategoryFilterCubit, String?>(
                builder: (context, selectedCategory) {
                  // 🔹 Updated BlocBuilder for combined filters
                  return BlocBuilder<SearchFilterCubit, SearchFilterState>(
                    builder: (context, filterState) {
                      final showFavoritesOnly = filterState.showFavoritesOnly;
                      final showComboOnly = filterState.showComboOnly;

                      return BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, favState) {
                          // Start with search-filtered items
                          List<Map<String, dynamic>> finalItems =
                              List<Map<String, dynamic>>.from(
                                searchState.filteredItems,
                              );

                          // 🔹 Category filter
                          if (selectedCategory != null) {
                            finalItems = finalItems
                                .where(
                                  (item) =>
                                      item['category'] == selectedCategory,
                                )
                                .toList();
                          }

                          // 🔹 Favorites filter
                          if (showFavoritesOnly) {
                            final favoriteIds = favState.favorites
                                .map((e) => e['id'].toString())
                                .toSet();

                            finalItems = finalItems.where((item) {
                              final itemId = item['id'].toString();
                              return favoriteIds.contains(itemId);
                            }).toList();
                          }

                          // 🔹 Combo food filter
                          if (showComboOnly) {
                            finalItems = finalItems
                                .where((item) => item['isCompo'] == true)
                                .toList();
                          }
                          final double minPrice = filterState.minPrice;
                          final double maxPrice = filterState.maxPrice;
                          finalItems = finalItems.where((item) {
                            final price = (item['price'] as num).toDouble();
                            return price >= minPrice && price <= maxPrice;
                          }).toList();
                          // 🔹 Empty state
                          if (finalItems.isEmpty) {
                            return const Center(
                              child: Text("No Food Items Found"),
                            );
                          }

                          // 🔹 Grid view
                          return GridView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: finalItems.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.72,
                                ),
                            itemBuilder: (context, index) {
                              return FoodCard(food: finalItems[index]);
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
