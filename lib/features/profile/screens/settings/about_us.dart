import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "About us"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // Logo and Name
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/Logo.jpeg', // replace with your logo path
                    height: 100,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Arafa Hotel Vallikkappatta",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Fresh home food with 10 years of flavor served with love",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About Section
            const Text(
              "About Us",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Arafa Hotel Vallikkappatta has 10 years of experience in providing good home food, "
              "hot and cool items, and delicious dishes with no lag. "
              "We offer several categories of food including breads, meals, biryani, roast, and more. "
              "Our signature items are Biryani rice with Kadai, Vellppam Mutta Roast, and Porotta Beef. "
              "We bring authentic hometown taste to everyone in the area. "
              "We also provide due payment facilities for our valued customers.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            // Vision / Goal
            const Text(
              "Our Vision",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "To bring authentic hometown taste to everyone in the area and make ordering food easy and accessible for all.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            // Founder / Team
            const Text(
              "Founder",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Ajmal is the man who made this hotel successful with his excellent service and delicious food. "
              "I am his son, Ashfaq, an IT professional, and this is the first project I developed for our hotel — "
              "a user-friendly app to make delivery and ordering easier for everyone.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            // Location & Timings
            const Text(
              "Location & Timings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Address: Vallikkappatta, Padinatumuri Road",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Timing Table
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
              },
              children: const [
                TableRow(
                  decoration: BoxDecoration(color: AppColors.primaryOrange),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Day",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Timing",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Monday - Thursday"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("5:00 AM - 7:00 PM"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Friday"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Closed"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Saturday - Sunday"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("5:00 AM - 7:00 PM"),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Contact Info
            const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Phone: 7034358661, 9048591273",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // App Credits
            const Center(
              child: Column(
                children: [
                  Text(
                    "App Developed By Ashfaq",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "version 0.1",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
