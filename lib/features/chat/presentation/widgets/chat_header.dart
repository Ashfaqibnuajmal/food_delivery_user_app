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
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Row(
        children: [
          // 🔙 Back Button
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new),
          ),

          const SizedBox(width: 6),

          // 👤 Profile Avatar
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 10),

          // 📝 Title + Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: bigBold),
              const SizedBox(height: 2),
              Text(subtitle, style: greySmallTextStyle),
            ],
          ),

          const Spacer(),

          // 📞 Optional actions
          IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}
