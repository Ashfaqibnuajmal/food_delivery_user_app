import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/home/logic/cubit/food_portion_cubit.dart';
import 'package:food_user_app/features/home/presentation/widgets/food_details/food_details_add_to_cart.dart';
import 'package:food_user_app/features/home/presentation/widgets/food_details/food_details_body.dart';

class FoodDetails extends StatefulWidget {
  final String foodItemId;
  const FoodDetails({super.key, required this.foodItemId});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("FoodItems")
            .doc(widget.foodItemId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("❌ Food details not found"));
          }

          final food = snapshot.data!;
          final data = food.data() as Map<String, dynamic>;

          final image = data['imageUrl'] ?? '';
          final name = data['name'] ?? 'Unknown';
          final prepTime = data['prepTimeMinutes'] ?? 0;
          final price = data['price'] ?? 0;
          final halfPrice = data['halfPrice'] ?? 0;
          final isHalfAvailable = data['isHalfAvailable'] ?? false;

          return BlocProvider(
            create: (_) => FoodPortionCubit(),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: FoodDetailsBody(foodItemId: widget.foodItemId),
              bottomNavigationBar: BlocBuilder<FoodPortionCubit, bool>(
                builder: (context, isHalfSelected) {
                  return FoodDetailsAddToCart(
                    foodItemId: widget.foodItemId,
                    name: name,
                    price: price.toDouble(),
                    halfPrice: halfPrice.toDouble(),
                    prepTime: prepTime,
                    imageUrl: image,
                    isHalfSelected: isHalfSelected,
                    isHalfAvailable: isHalfAvailable,
                    isTodayOffer: data['isTodayOffer'] ?? false,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
