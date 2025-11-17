import 'package:flutter/material.dart';
import 'custom_text_field.dart'; // your generic text field

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: "Mobile Number",
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Phone number is required";
        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return "Enter a valid 10-digit phone number";
        }
        return null;
      },
      maxLength: 10,
    );
  }
}
