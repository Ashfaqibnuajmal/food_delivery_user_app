import 'package:flutter/material.dart';
import 'package:food_user_app/core/services/search_service.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/category.dart';
import 'package:food_user_app/core/widgets/search_bar.dart';
import 'package:food_user_app/features/home/presentation/widgets/search_page/search_food_grid.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SearchService.createSyncedController(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Search item"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SearchBarController(controller: controller),
              const SizedBox(height: 20),
              const CategoryList(),
              const SearchFoodGrid(collection: "FoodItems"),
            ],
          ),
        ),
      ),
    );
  }
}
