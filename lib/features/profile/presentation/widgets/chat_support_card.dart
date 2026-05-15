import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/features/chat/presentation/screens/chat_and_support.dart';

class ChatSupportCard extends StatelessWidget {
  const ChatSupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatAndSupport(
                userId: FirebaseAuth.instance.currentUser!.uid,
              ),
            ),
          );
        },
        child: const ListTile(
          leading: Icon(Icons.call, color: Colors.black),
          title: Text(
            "Chat with us",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
