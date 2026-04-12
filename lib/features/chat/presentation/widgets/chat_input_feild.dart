import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Row(
        children: [
          // ✍️ Text Field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // 📤 Send Button Only
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, TextEditingValue value, child) {
              final isTyping = value.text.trim().isNotEmpty;

              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: isTyping ? onSend : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
