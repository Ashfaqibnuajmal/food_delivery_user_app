import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/home/logic/cubit/today_offer_cubit.dart';

class TodayOfferFooter extends StatelessWidget {
  const TodayOfferFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("FoodItems")
          .where("isTodayOffer", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        return BlocBuilder<TodayOfferCubit, int>(
          builder: (context, currentIndex) {
            final total = snapshot.data!.docs.length;
            final count = total >= 3 ? 3 : total;
            final activeIndex = currentIndex % count;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(count, (index) {
                final isActive = activeIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isActive ? 10 : 8,
                  height: isActive ? 10 : 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.primaryOrange
                        : Colors.grey.withOpacity(0.4),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}
