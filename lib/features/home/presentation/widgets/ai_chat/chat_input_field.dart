import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/home/logic/bloc/ai_chat_bloc.dart';
import 'package:food_user_app/features/home/logic/bloc/ai_chat_event.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController userPromptController;

  const ChatInputField({super.key, required this.userPromptController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: userPromptController,
                decoration: const InputDecoration(
                  hintText: "Type something...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                final prompt = userPromptController.text.trim();
                if (prompt.isNotEmpty) {
                  context.read<AiChatBloc>().add(GenerateContentEvent(prompt));
                  userPromptController.clear();
                }
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
