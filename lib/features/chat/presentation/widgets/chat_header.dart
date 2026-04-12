import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class ChatHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const ChatHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),

              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: bigBold),
                  const SizedBox(height: 2),
                  Text(subtitle, style: greySmallTextStyle),
                ],
              ),
            ],
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
        ],
      ),
    );
  }
}
