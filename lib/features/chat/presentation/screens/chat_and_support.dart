import 'package:flutter/material.dart';
import 'package:food_user_app/features/chat/controller/chat_controller.dart';
import 'package:food_user_app/features/chat/presentation/widgets/chat_header.dart';
import 'package:food_user_app/features/chat/presentation/widgets/chat_input_feild.dart';
import 'package:food_user_app/features/chat/presentation/widgets/chat_message_list.dart';

class ChatAndSupport extends StatefulWidget {
  final String userId; // Current user ID

  const ChatAndSupport({super.key, required this.userId});

  @override
  State<ChatAndSupport> createState() => _ChatAndSupportState();
}

class _ChatAndSupportState extends State<ChatAndSupport> {
  final ChatController controller = ChatController();
  @override
  void initState() {
    super.initState();
    controller.loadUserInfo(userId: widget.userId, setState: setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(
              title: "Admin",
              subtitle: "Online",
              onBack: () {
                Navigator.pop(context);
              },
            ),

            ChatMessagesList(
              userId: widget.userId,
              messageStream: controller.getMessages(widget.userId),
              scrollController: controller.scrollController,
              onDeleteMessage: (messageId) {
                controller.showDeleteDialog(context, widget.userId, messageId);
              },
            ),
            ChatInputField(
              controller: controller.messageController,
              onSend: () => controller.sendMessage(widget.userId),
            ),
          ],
        ),
      ),
    );
  }
}
