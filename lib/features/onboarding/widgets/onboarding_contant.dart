import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:gap/gap.dart';

class OnboardingContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Responsive values
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: height * 0.48,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),

              Positioned(
                top: height * 0.04,
                left: width * 0.06,
                right: width * 0.06,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),

          Gap(height * 0.06),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: Column(
              children: [
                Text(
                  title,
                  style: blackBoldBigTextStyle.copyWith(
                    fontSize: width * 0.075,
                  ),
                  textAlign: TextAlign.center,
                ),

                Gap(height * 0.02),

                Text(
                  subtitle,
                  style: lightBlackTextStyle.copyWith(
                    fontSize: width * 0.04,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
