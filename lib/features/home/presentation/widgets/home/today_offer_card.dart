import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_state.dart';
import 'package:food_user_app/features/home/logic/cubit/today_offer_cubit.dart';
import 'package:food_user_app/features/home/presentation/screens/food_details.dart';
import 'package:shimmer/shimmer.dart';

class TodayOfferCard extends StatelessWidget {
  const TodayOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("FoodItems")
          .where("isTodayOffer", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Today no offer available!"));
        }

        final foodItems = snapshot.data!.docs;

        return CarouselSlider.builder(
          itemCount: foodItems.length,
          itemBuilder: (context, index, realIdx) {
            final food = foodItems[index].data()! as Map<String, dynamic>;
            final doc = foodItems[index];
            final id = doc.id;

            return Container(
              width: 460,
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 130,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    food['imageUrl'] == null ||
                                        (food['imageUrl'] as String).isEmpty
                                    ? const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : Image.network(
                                        food['imageUrl'],
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  height: 90,
                                                  width: 90,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                      ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                food["name"] ?? "",
                                textAlign: TextAlign.center,
                                style: smallBold,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -15,
                          left: -10,
                          child: Image.asset(
                            'assets/offer.png',
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "GET 50% OFFER TODAY!",
                              textAlign: TextAlign.center,
                              style: offer,
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FoodDetails(foodItemId: id),
                                  ),
                                );
                              },
                              child: BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  final bool inCart = state.cartItems.any(
                                    (it) =>
                                        it['id']?.toString() == id.toString(),
                                  );
                                  if (inCart) {
                                    return SizedBox(
                                      height: 30,
                                      width: 90,
                                      child: Material(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(25),
                                        elevation: 3,
                                        child: const Center(
                                          child: Text(
                                            "Ordered",
                                            style: orangeBoldSmallTextStyle,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 30,
                                    width: 90,
                                    child: Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(25),
                                      elevation: 3,
                                      child: const Center(
                                        child: Text(
                                          "Order Now",
                                          style: orangeBoldSmallTextStyle,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 190,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            enlargeFactor: 0.18,
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              context.read<TodayOfferCubit>().changeIndex(index);
            },
          ),
        );
      },
    );
  }
}
