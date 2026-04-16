import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? name;
  final VoidCallback onChangeTap;

  const AddressCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.name,
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
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (name != null) ...[
                const SizedBox(height: 2),
                Text(
                  name!,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
