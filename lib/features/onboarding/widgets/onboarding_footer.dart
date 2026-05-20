// onboarding_footer.dart

import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingFooter extends StatefulWidget {
  final PageController controller;
  final VoidCallback onDone;

  const OnboardingFooter({
    super.key,
    required this.controller,
    required this.onDone,
  });

  @override
  State<OnboardingFooter> createState() => _OnboardingFooterState();
}

class _OnboardingFooterState extends State<OnboardingFooter> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_pageListener);
  }

  void _pageListener() {
    final int newPage = widget.controller.page?.round() ?? 0;

    if (newPage != currentPage) {
      setState(() {
        currentPage = newPage;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_pageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Responsive values
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.025,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmoothPageIndicator(
            controller: widget.controller,
            count: 3,
            effect: WormEffect(
              activeDotColor: AppColors.primaryOrange,
              dotColor: Colors.grey.shade300,
              dotHeight: width * 0.03,
              dotWidth: width * 0.03,
            ),
          ),

          Gap(height * 0.025),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentPage < 2)
                TextButton(
                  onPressed: () {
                    widget.controller.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    "Skip",
                    style: orangeTextStyle.copyWith(fontSize: width * 0.042),
                  ),
                )
              else
                SizedBox(width: width * 0.15),

              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.12),
                      spreadRadius: 5,
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (currentPage == 2) {
                      widget.onDone();
                    } else {
                      widget.controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryOrange,
                    elevation: 1,
                    padding: EdgeInsets.symmetric(
                      horizontal: currentPage == 2
                          ? width * 0.05
                          : width * 0.035,
                      vertical: height * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: currentPage == 2
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Get Started!",
                              style: orangeBoldTextStyle.copyWith(
                                fontSize: width * 0.042,
                              ),
                            ),

                            SizedBox(width: width * 0.02),

                            Icon(
                              Icons.arrow_forward_ios,
                              size: width * 0.045,
                              color: AppColors.primaryOrange,
                            ),
                          ],
                        )
                      : Icon(
                          Icons.arrow_forward_ios,
                          size: width * 0.06,
                          color: AppColors.primaryOrange,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
