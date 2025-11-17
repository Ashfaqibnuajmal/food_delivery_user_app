import 'package:flutter/material.dart';
import 'package:food_user_app/core/services/search_service.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/search_bar.dart';
import 'package:food_user_app/features/home/presentation/widgets/best_compo/compo_food_grid.dart';

class BestCompoScreen extends StatelessWidget {
  const BestCompoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SearchService.createSyncedController(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Best Compo"),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchBarController(controller: controller),
            const SizedBox(height: 30),
            const CompoFoodGrid(),
          ],
        ),
      ),
    );
  }
}
