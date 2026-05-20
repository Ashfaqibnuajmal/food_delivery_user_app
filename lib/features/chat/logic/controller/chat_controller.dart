import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/features/chat/services/chat_services.dart';
import 'package:food_user_app/features/chat/presentation/widgets/chat_delete_message.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController {
  final UserChatServices _chatService = UserChatServices();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final String adminId = "ADMIN_HOTEL_001";

  String userName = "";
  String userEmail = "";

  /// Load user info
  Future<void> loadUserInfo({
    required String userId,
    required Function(VoidCallback fn) setState,
  }) async {
    try {
      final data = await _chatService.getUserInfo(userId);

      if (data != null) {
        setState(() {
          userName = data['name'] ?? "User";
          userEmail = data['email'] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Error loading user info: $e");
    }
  }

  Future<void> makeCall() async {
    final Uri url = Uri(scheme: "tel", path: '9846100721');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch call");
    }
  }

  /// Send message
  Future<void> sendMessage(String userId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    await _chatService.sendMessage(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      text: text,
      adminId: adminId,
    );

    scrollToBottom();
  }

  /// Scroll
  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  /// Delete dialog
  void showDeleteDialog(BuildContext context, String userId, String messageId) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteMessageDialog(
          onDelete: () async {
            await _chatService.deleteMessage(userId, messageId);
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> getMessages(String userId) {
    return _chatService.getMessages(userId);
  }

  /// Dispose
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
  }
}
