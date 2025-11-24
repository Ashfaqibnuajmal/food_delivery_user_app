import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';

Widget cartBadge(int count) {
  if (count <= 0) return const Icon(Icons.shopping_cart);

  final display = count > 99 ? '99+' : count.toString();

  return Stack(
    clipBehavior: Clip.none,
    children: [
      const Icon(Icons.shopping_cart),
      // Positioned badge
      Positioned(
        right: -7,
        top: -7,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
          child: Center(
            child: Text(
              display,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
