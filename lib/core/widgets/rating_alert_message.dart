// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_user_app/core/services/rating_service.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

Future<void> showFoodRatingDialog(BuildContext context, String foodId) async {
  double userRating = 0.0;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🖼️ Image Header (Full Width)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                "assets/rating_star.png", // your top image
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // 📝 Title
            const Text(
              "How Would You Rate This Food?",
              textAlign: TextAlign.center,
              style: bigBold,
            ),

            const SizedBox(height: 8),

            // 💬 Subtitle
            Text(
              "Your feedback helps us improve!",
              textAlign: TextAlign.center,
              style: anyColorTextStyleSmall.copyWith(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ⭐ Rating Bar
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              allowHalfRating: true,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                userRating = rating;
              },
            ),

            const SizedBox(height: 25),

            // ✅ Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (userRating == 0.0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a rating first."),
                      ),
                    );
                    return;
                  }

                  await RatingServices.saveUserRating(foodId, userRating);
                  Navigator.pop(context);
                },
                child: Text(
                  "Submit",
                  style: anyColorTextStyle.copyWith(color: AppColors.black),
                ),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No, Thanks", style: greyTextStyle),
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
