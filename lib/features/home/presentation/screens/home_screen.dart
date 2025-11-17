import 'package:flutter/material.dart';
import 'package:food_user_app/core/widgets/category.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/best_compo_grid.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/best_compo_title.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/food_item_list.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/home_appbar.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/recommended_title.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/search_bar_widget.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/today_offer_card.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/today_offer_footer.dart';
import 'package:food_user_app/features/home/presentation/widgets/home/today_offer_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarWidget(),
            SizedBox(height: 30),
            TodayOfferTitle(),
            SizedBox(height: 25),
            TodayOfferCard(),
            SizedBox(height: 12),
            TodayOfferFooter(),
            SizedBox(height: 40),
            BestCompoHeading(),
            SizedBox(height: 10),
            BestCompoCardGrid(),
            SizedBox(height: 30),
            RecommendedTitle(),
            SizedBox(height: 20),
            SizedBox(height: 95, child: CategoryList()),
            SizedBox(height: 20),
            FoodItemsList(),
          ],
        ),
      ),
    );
  }
}
