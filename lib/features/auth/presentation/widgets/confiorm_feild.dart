import 'package:flutter/material.dart';
import 'custom_text_field.dart'; // your generic text field

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController matchController;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.matchController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: "Confirm Password",
      obscureText: true,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please confirm your password";
        } else if (value != matchController.text) {
          return "Password do not match";
        }
        return null;
      },
    );
  }
}
