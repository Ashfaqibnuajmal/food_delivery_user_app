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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: widget.controller,
            count: 3,
            effect: const WormEffect(
              activeDotColor: AppColors.primaryOrange,
              dotColor: Colors.grey,
              dotHeight: 12,
              dotWidth: 12,
            ),
          ),
          const Gap(20),
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
                  child: const Text("Skip", style: orangeTextStyle),
                )
              else
                const SizedBox(width: 60), // To keep layout aligned

              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1),
                      spreadRadius: 7,
                      blurRadius: 40,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (currentPage == 2) {
                      widget.onDone(); // Go to next screen
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    elevation: 1,
                  ),
                  child: currentPage == 2
                      ? const Row(
                          children: [
                            Text("Get Started!", style: orangeBoldTextStyle),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.primaryOrange,
                            ),
                          ],
                        )
                      : const Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
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
