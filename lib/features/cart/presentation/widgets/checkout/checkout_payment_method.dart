import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedPayment;
  final Function(String) onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedPayment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Payment Method", style: bigBold),
        RadioListTile<String>(
          value: "cod",
          groupValue: selectedPayment,
          activeColor: AppColors.primaryOrange,
          onChanged: (value) => onChanged(value!),
          title: const Text("Cash On Delivery"),
        ),
        RadioListTile<String>(
          value: "razorpay",
          groupValue: selectedPayment,
          activeColor: AppColors.primaryOrange,
          onChanged: (value) => onChanged(value!),
          title: const Text("Razorpay"),
        ),
      ],
    );
  }
}
