import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';

class PrivacyAndPolicy extends StatelessWidget {
  const PrivacyAndPolicy({super.key});

  Widget sectionCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Privacy & Policy"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Welcome to Arafa Hotel Vallikkappatta App. We value your privacy and want to explain how we handle your information.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            // Sections without bullets
            sectionCard(
              icon: Icons.info_outline,
              title: "1. Information We Collect",
              content:
                  "We collect your name, email, phone number, and address. "
                  "This information is collected only for app functionality — to know who orders the food, authenticate your account, contact you regarding deliveries, and provide smooth app experience.",
            ),
            sectionCard(
              icon: Icons.work_outline,
              title: "2. How We Use Your Information",
              content:
                  "We use your information to process and deliver your orders accurately, provide authentication and verify your account, contact you when your food is delivered, and improve app experience with a smooth UI and user-friendly design.",
            ),
            sectionCard(
              icon: Icons.security,
              title: "3. Data Sharing & Security",
              content:
                  "We do not share your data with anyone. All information is stored securely with proper protection.",
            ),
            sectionCard(
              icon: Icons.verified_user,
              title: "4. User Rights",
              content:
                  "If you have any issues or doubts, you can check your data at our hotel or contact us.",
            ),
            sectionCard(
              icon: Icons.update,
              title: "5. Updates to Privacy Policy",
              content:
                  "Whenever we update our Privacy & Policy, you will be notified through the app.",
            ),
            sectionCard(
              icon: Icons.contact_phone,
              title: "6. Contact Us",
              content: "For any concerns or doubts, contact us at 9846100721.",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
