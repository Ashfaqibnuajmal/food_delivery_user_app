// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/enum/payment_mode.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/cart/data/services/payment_service.dart';
import 'package:food_user_app/features/cart/logic/cubit/payment/select_payment_cubit.dart';

class StripePaymentButton extends StatefulWidget {
  final int totalAmount;

  const StripePaymentButton({super.key, required this.totalAmount});

  @override
  State<StripePaymentButton> createState() => _StripePaymentButtonState();
}

class _StripePaymentButtonState extends State<StripePaymentButton> {
  bool stripePaid = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectPaymentCubit, PaymentMode>(
      builder: (context, paymentMode) {
        if (paymentMode == PaymentMode.stripe && !stripePaid) {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () async {
                try {
                  await PaymentService().makePayment(widget.totalAmount);

                  CustomSnackBar.showSuccess(
                    context,
                    message: "Payment Successfully",
                  );

                  setState(() => stripePaid = true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Failed")),
                  );
                  CustomSnackBar.redCustomSnackBar(context, "Payment Failed!");
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pay Now", style: mediumBold),
                  SizedBox(width: 8),
                  Icon(Icons.payment, color: Colors.black),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
