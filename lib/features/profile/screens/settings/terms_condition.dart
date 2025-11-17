import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({super.key});

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
      appBar: const CustomAppBar(title: "Terms & Conditions"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Welcome to Arafa Hotel Vallikkappatta App. By using our app, you agree to the following terms and conditions.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            // Sections
            sectionCard(
              icon: Icons.info_outline,
              title: "1. App Usage",
              content:
                  "You agree to use the app only for ordering food for personal and non-commercial purposes. Any misuse of the app may lead to account suspension.",
            ),
            sectionCard(
              icon: Icons.fastfood,
              title: "2. Orders and Payments",
              content:
                  "All orders placed through the app are subject to availability. Payment must be made either online or as per the chosen method. We reserve the right to cancel or modify orders in case of errors or unavailability.",
            ),
            sectionCard(
              icon: Icons.location_on,
              title: "3. Delivery",
              content:
                  "We will make reasonable efforts to deliver your orders on time. Delivery times are estimated and may vary due to unforeseen circumstances. You must provide accurate delivery information.",
            ),
            sectionCard(
              icon: Icons.security,
              title: "4. Data and Privacy",
              content:
                  "We collect your personal information such as name, email, phone number, and address solely for order processing and app functionality. Your data will be stored securely and will not be shared with third parties.",
            ),
            sectionCard(
              icon: Icons.rule,
              title: "5. Liability",
              content:
                  "Arafa Hotel Vallikkappatta is not liable for any indirect, incidental, or consequential damages arising from the use of the app. We strive to provide accurate information but cannot guarantee perfection.",
            ),
            sectionCard(
              icon: Icons.update,
              title: "6. Updates to Terms",
              content:
                  "We may update these Terms & Conditions from time to time. Users will be notified of any changes through the app. Continued use of the app implies acceptance of the updated terms.",
            ),
            sectionCard(
              icon: Icons.contact_phone,
              title: "7. Contact Us",
              content:
                  "If you have any questions or concerns regarding these Terms & Conditions, please contact us at 9846100721.",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
