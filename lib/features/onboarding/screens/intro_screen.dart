import 'package:flutter/material.dart';
import 'package:food_user_app/core/routes/app_routes.dart';
import 'package:food_user_app/features/onboarding/widgets/onboarding_contant.dart';
import 'package:food_user_app/features/onboarding/widgets/onboarding_footer.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: const [
                // // Page 1
                OnboardingContent(
                  imagePath: "assets/intro_image1.jpeg",
                  title: "Find Food For Love",
                  subtitle:
                      'Indulge in the exquisite flavors of our culinary masterpiece – a symphony of succulent grilled chicken, nestled on a bed of perfectly seasoned quinoa and adorned with a medley of vibrant, roasted vegetables.',
                ),
                // Page2
                OnboardingContent(
                  imagePath: "assets/intro_image2.jpeg",
                  title: "Swift & Safe Delivery",
                  subtitle:
                      "Your favorite meals delivered fresh and on time. With real-time tracking and careful handling, we make sure every order reaches you hot and fast — whether you're at home, work, or anywhere in between.        ",
                ),
                // Page3
                OnboardingContent(
                  imagePath: "assets/intro_image3.jpeg",
                  title: "Quality Food, Every Time",
                  subtitle:
                      'Our chefs prepare every dish with care, using fresh ingredients and clean cooking methods. We’re here to serve food that’s tasty, hygienic, and made to satisfy your cravings.',
                ),
              ],
            ),
          ),
          OnboardingFooter(
            controller: _controller,
            onDone: () {
              Navigator.pushReplacementNamed(context, AppRoutes.signUp);
            },
          ),
        ],
      ),
    );
  }
}
