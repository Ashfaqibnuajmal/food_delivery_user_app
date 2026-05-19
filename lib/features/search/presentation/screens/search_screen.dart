import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/services/search_service.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/category.dart';
import 'package:food_user_app/core/widgets/search_bar.dart';
import 'package:food_user_app/features/search/logic/cubit/search_filter_cubit.dart';
import 'package:food_user_app/features/search/logic/cubit/search_filter_state.dart';
import 'package:food_user_app/features/search/presentation/widgets/filter_bottom_sheet.dart';
import 'package:food_user_app/features/search/presentation/widgets/search_food_grid.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SearchService.createSyncedController(context);

    return BlocProvider(
      create: (context) => SearchFilterCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Search Food's"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SearchBarController(controller: controller),
                    ),
                    const SizedBox(width: 10),
                    // 🔹 Filter Icon
                    BlocBuilder<SearchFilterCubit, SearchFilterState>(
                      builder: (context, filterState) {
                        final bool isPriceFilterActive =
                            filterState.minPrice != 10 ||
                            filterState.maxPrice != 150;
                        final isActive =
                            filterState.showFavoritesOnly ||
                            filterState.showComboOnly ||
                            isPriceFilterActive;

                        return Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isActive
                                  ? AppColors.primaryOrange
                                  : AppColors.primaryOrange.withOpacity(0.3),
                              width: isActive ? 2 : 1,
                            ),
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_list_rounded,
                              color: isActive
                                  ? AppColors.primaryOrange
                                  : Colors.black,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (modalContext) => BlocProvider.value(
                                  value: context.read<SearchFilterCubit>(),
                                  child: const FilterBottomSheet(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const CategoryList(),
                const SearchFoodGrid(collection: "FoodItems"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
