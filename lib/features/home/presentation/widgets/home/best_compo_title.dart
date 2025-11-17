import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/home/presentation/screens/best_compo_screen.dart';

class BestCompoHeading extends StatelessWidget {
  const BestCompoHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Best Compo", style: homePageTitles),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BestCompoScreen()),
            );
          },
          child: const Text("View", style: viewTextStyle),
        ),
      ],
    );
  }
}
