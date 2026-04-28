import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/cart/data/services/payment_service.dart';
import 'package:food_user_app/core/enum/payment_mode.dart';
import 'package:food_user_app/features/cart/logic/cubit/payment/select_payment_cubit.dart';
import 'package:food_user_app/features/checkout/presentation/widgets/payment_success_overlay.dart';

class StripePayButton extends StatelessWidget {
  final double total;
  final bool stripePaid;
  final VoidCallback onPaid;

  const StripePayButton({
    super.key,
    required this.total,
    required this.stripePaid,
    required this.onPaid,
  });

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
                  await PaymentService().makePayment(total.toInt());

                  // ✅ Show animation instead of snackbar
                  await PaymentSuccessOverlay.show(
                    context,
                    onComplete: onPaid, // called after animation closes
                  );
                } catch (e) {
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
