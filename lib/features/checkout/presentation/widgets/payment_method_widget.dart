// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/enum/payment_mode.dart';
import 'package:food_user_app/features/cart/logic/cubit/payment/select_payment_cubit.dart';

class PaymentMethodWidget extends StatelessWidget {
  final SelectPaymentCubit paymentCubit;
  const PaymentMethodWidget({super.key, required this.paymentCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectPaymentCubit, PaymentMode>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 30),
            const Text("Payment Method", style: bigBold),
            RadioListTile<PaymentMode>(
              value: PaymentMode.cod,
              activeColor: AppColors.primaryOrange,
              groupValue: state,
              onChanged: (selected) {
                if (selected != null) paymentCubit.changeMode(selected);
              },
              title: Text(paymentModeToString(PaymentMode.cod)),
            ),
            RadioListTile<PaymentMode>(
              value: PaymentMode.stripe,
              activeColor: AppColors.primaryOrange,
              groupValue: state,
              onChanged: (selected) {
                if (selected != null) paymentCubit.changeMode(selected);
              },
              title: Text(paymentModeToString(PaymentMode.stripe)),
            ),
          ],
        );
      },
    );
  }
}
