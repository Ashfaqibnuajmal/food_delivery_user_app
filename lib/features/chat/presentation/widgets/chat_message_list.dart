import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class ChatMessagesList extends StatelessWidget {
  final String userId;
  final Stream<QuerySnapshot> messageStream;
  final ScrollController scrollController;
  final Function(String messageId) onDeleteMessage;

  const ChatMessagesList({
    super.key,
    required this.userId,
    required this.messageStream,
    required this.scrollController,
    required this.onDeleteMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            );
          }

          // ❌ No Messages
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No messages yet. Start chatting!",
                style: lightBlackTextStyle,
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // ✅ Auto scroll
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final isUser = data['senderId'] == userId;

              // ⏱ Timestamp safe handling
              final timestamp = data['timestamp'] as Timestamp?;
              final timeStr = timestamp != null
                  ? TimeOfDay.fromDateTime(timestamp.toDate()).format(context)
                  : "";

              final messageId = docs[index].id;

              return GestureDetector(
                onLongPress: isUser ? () => onDeleteMessage(messageId) : null,
                child: Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primaryOrange
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                        topLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(0),
                        topRight: isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // 💬 Message
                        Text(
                          data['message'] ?? "",
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // ⏰ Time
                        Text(
                          timeStr,
                          style: TextStyle(
                            color: isUser ? Colors.white70 : Colors.black45,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
