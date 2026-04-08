import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';

class ChatAndSupport extends StatefulWidget {
  final String userId; // Current user ID

  const ChatAndSupport({super.key, required this.userId});

  @override
  State<ChatAndSupport> createState() => _ChatAndSupportState();
}

class _ChatAndSupportState extends State<ChatAndSupport> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String adminId = "ADMIN_HOTEL_001"; // Admin ID

  // ✅ FIX 1: Fetch user name/email from Firestore "Users" collection
  // so the parent chat doc knows WHO is chatting
  String _userName = "";
  String _userEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // ✅ FIX 2: Load user info once, so we can write it to the chat document
  Future<void> _loadUserInfo() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'] ?? "User";
          _userEmail = data['email'] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Error loading user info: $e");
    }
  }

  // ✅ FIX 3: Dispose controllers properly
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ FIX 4: Auto-scroll to bottom when new messages arrive
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // ✅ FIX 5: Send message AND update parent chat document with user metadata
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    final chatDocRef = FirebaseFirestore.instance
        .collection("Chats")
        .doc(widget.userId);

    // Write/update the PARENT chat document with user info
    // This is what the admin reads to show the list of users
    await chatDocRef.set({
      "userId": widget.userId,
      "userName": _userName,
      "userEmail": _userEmail,
      "lastMessage": text,
      "lastMessageTime": FieldValue.serverTimestamp(),
      "unreadByAdmin": FieldValue.increment(1), // track unread count for admin
    }, SetOptions(merge: true));

    // Add the message to the subcollection
    await chatDocRef.collection("messages").add({
      "message": text,
      "senderId": widget.userId,
      "receiverId": adminId,
      "timestamp":
          FieldValue.serverTimestamp(), // ✅ FIX 6: Use server timestamp
      "isRead": false,
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chat &",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Support",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Messages List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Chats")
                    .doc(widget.userId) // ✅ Each user has their OWN chat doc
                    .collection("messages")
                    .orderBy("timestamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No messages yet. Start chatting with admin!",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  // ✅ FIX 7: Auto-scroll when new messages come in
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      // Check if the sender is user or admin
                      final isUser = data['senderId'] == widget.userId;

                      // ✅ FIX 8: Handle null timestamp (pending server write)
                      final timestamp = data['timestamp'] as Timestamp?;
                      final timeStr = timestamp != null
                          ? TimeOfDay.fromDateTime(
                              timestamp.toDate(),
                            ).format(context)
                          : "";

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 10.0,
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
                              Text(
                                data['message'] ?? "",
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.white70
                                      : Colors.black45,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Input Field
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Type something...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage, // ✅ FIX 9: Extracted to method
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
