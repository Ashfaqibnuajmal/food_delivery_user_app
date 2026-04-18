import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class RecommendedTitle extends StatelessWidget {
  const RecommendedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            height: 1.5,
            decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const Text("Food Items", style: homePageTitles),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 1.5,
            decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
