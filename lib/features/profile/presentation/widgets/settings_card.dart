import 'package:flutter/material.dart';
import 'package:food_user_app/features/settings/settings.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
        child: const ListTile(
          leading: Icon(Icons.settings, color: Colors.black),
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
