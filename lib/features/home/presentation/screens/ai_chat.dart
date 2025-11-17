import 'package:flutter/material.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/features/home/presentation/widgets/ai_chat/chat_input_field.dart';
import 'package:food_user_app/features/home/presentation/widgets/ai_chat/chat_message_list.dart';

class AiChat extends StatelessWidget {
  const AiChat({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userPromptController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Foodie"),
      body: Column(
        children: [
          const ChatMessageList(),
          ChatInputField(userPromptController: userPromptController),
        ],
      ),
    );
  }
}
