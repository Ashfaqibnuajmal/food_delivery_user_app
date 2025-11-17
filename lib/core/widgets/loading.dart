import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:food_user_app/core/theme/app_color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.label, this.isSplash = false});

  final String? label;
  final bool isSplash;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black45),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSplash
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: AppColors.primaryOrange,
                      size: 40,
                    )
                  : LoadingAnimationWidget.hexagonDots(
                      color: AppColors.primaryOrange,
                      size: 40,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
