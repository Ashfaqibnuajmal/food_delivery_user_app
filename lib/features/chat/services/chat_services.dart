// =======================
// 📁 user_chat_services.dart
// =======================

import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user info
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    final doc = await _firestore.collection("Users").doc(userId).get();
    return doc.data();
  }

  /// Send message
  Future<void> sendMessage({
    required String userId,
    required String userName,
    required String userEmail,
    required String text,
    required String adminId,
  }) async {
    final chatDocRef = _firestore.collection("Chats").doc(userId);

    await chatDocRef.set({
      "userId": userId,
      "userName": userName,
      "userEmail": userEmail,
      "lastMessage": text,
      "lastMessageTime": FieldValue.serverTimestamp(),
      "unreadByAdmin": FieldValue.increment(1),
    }, SetOptions(merge: true));

    await chatDocRef.collection("messages").add({
      "message": text,
      "senderId": userId,
      "receiverId": adminId,
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });
  }

  /// Stream messages
  Stream<QuerySnapshot> getMessages(String userId) {
    return _firestore
        .collection("Chats")
        .doc(userId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }

  /// Delete message
  Future<void> deleteMessage(String userId, String messageId) async {
    await _firestore
        .collection("Chats")
        .doc(userId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
}
