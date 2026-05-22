// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/checkout/controller/checkout_controller.dart';
import 'package:food_user_app/features/checkout/cubit/checkout/checkout_cubit.dart';
import 'package:food_user_app/features/checkout/presentation/widgets/payment_method_widget.dart';
import 'package:food_user_app/core/enum/payment_mode.dart';
import 'package:food_user_app/features/checkout/cubit/payment/select_payment_cubit.dart';
import 'package:food_user_app/features/checkout/presentation/widgets/checkout_price_row.dart';
import 'package:food_user_app/features/checkout/presentation/widgets/place_order_button.dart';
import 'package:food_user_app/features/checkout/cubit/payment/stripe_payment_cubit.dart';
import '../widgets/delivery_address_section.dart';
import 'package:food_user_app/features/checkout/presentation/widgets/stripe_payment_button.dart';
import 'package:food_user_app/features/order/presentation/screen/order_history_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final paymentCubit = context.read<SelectPaymentCubit>();

    return BlocProvider(
      create: (_) => StripePaymentCubit(),
      child: Builder(
        builder: (context) {
          final controller = CheckoutController(context);

          return BlocConsumer<CheckoutCubit, CheckoutState>(
            listener: (context, state) async {
              if (state is CheckoutSuccess) {
                await controller.afterOrderSuccess();

                CustomSnackBar.showSuccess(
                  context,
                  message: "✅ Order Placed Successfully",
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                );
              } else if (state is CheckoutFailure) {
                CustomSnackBar.showSuccess(
                  context,
                  message: "Failed ${state.message}",
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(title: "Checkout"),
                body: state is CheckoutLoading
                    ? const Center(child: LoadingIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DeliveryAddressSection(),
                            const SizedBox(height: 16),

                            PaymentMethodWidget(paymentCubit: paymentCubit),

                            const SizedBox(height: 25),

                            PriceSummary(
                              subtotal: subtotal,
                              discount: discount,
                              delivery: deliveryFee,
                              total: total,
                            ),

                            const SizedBox(height: 30),

                            BlocBuilder<StripePaymentCubit, bool>(
                              builder: (context, stripePaid) {
                                return StripePayButton(
                                  total: total,
                                  stripePaid: stripePaid,
                                  onPaid: () {
                                    context
                                        .read<StripePaymentCubit>()
                                        .markPaid();
                                  },
                                );
                              },
                            ),

                            BlocBuilder<SelectPaymentCubit, PaymentMode>(
                              builder: (context, paymentMode) {
                                return BlocBuilder<StripePaymentCubit, bool>(
                                  builder: (context, stripePaid) {
                                    final canPlaceOrder =
                                        paymentMode == PaymentMode.cod ||
                                        stripePaid;

                                    return canPlaceOrder
                                        ? PlaceOrderButton(
                                            subtotal: subtotal,
                                            discount: discount,
                                            total: total,
                                            controller: controller,
                                          )
                                        : const SizedBox.shrink();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
