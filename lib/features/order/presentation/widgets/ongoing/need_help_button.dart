import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/features/chat/presentation/screens/chat_and_support.dart';

class NeedHelpButton extends StatelessWidget {
  const NeedHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
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

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            border: Border.all(color: Colors.black, width: 0.5),
          ),

          child: const Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(Icons.call, color: Colors.black),

              SizedBox(width: 8),

              Text(
                'Need Help?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
