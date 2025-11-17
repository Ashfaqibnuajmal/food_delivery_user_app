import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/category/food_category_filter_cubit.dart';
import 'package:food_user_app/core/blocs/search/search_bloc.dart';
import 'package:food_user_app/core/blocs/search/search_event.dart';
import 'package:food_user_app/core/blocs/search/search_state.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/home/presentation/widgets/search_page/search_food_card.dart';

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

          final items = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

          // Send to Bloc once
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<FoodSearchBloc>().add(SetFoodItems(items));
          });

          return BlocBuilder<FoodSearchBloc, FoodSearchState>(
            builder: (context, state) {
              final filteredItems = state.filteredItems;
              return BlocBuilder<FoodCategoryFilterCubit, String?>(
                builder: (context, selectedCategory) {
                  final filteredByCategory = selectedCategory == null
                      ? filteredItems
                      : filteredItems
                            .where(
                              (item) => item['category'] == selectedCategory,
                            )
                            .toList();

                  if (filteredByCategory.isEmpty) {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 100),
                          Icon(
                            Icons.search_off_rounded,
                            size: 50,
                            color: AppColors.primaryOrange,
                          ),
                          Text("No Food Items Found!", style: emptyTextStyle),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredByCategory.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) {
                      final food = filteredByCategory[index];
                      return FoodCard(food: food);
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
