import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class TextLink extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TextLink({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: anyColorTextStyle.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
