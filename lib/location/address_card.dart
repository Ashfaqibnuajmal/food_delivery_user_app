import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final IconData icon;
  final String title; // label
  final String subtitle; // address
  final String phone; // phone
  final VoidCallback onChangeTap;

  const AddressCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.phone,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.black),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Label
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 4),

              /// 🔹 Address
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),

              const SizedBox(height: 2),

              /// 🔹 Phone
              Text(
                phone,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
