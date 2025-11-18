// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/cart/controller/checkout_controller.dart';
import 'package:food_user_app/features/cart/logic/cubit/checkout/checkout_cubit.dart';
import 'package:food_user_app/features/cart/presentation/widgets/checkout/checkout_payment_method.dart';
import 'package:food_user_app/features/cart/presentation/widgets/checkout/checkout_price_row.dart';
import 'package:food_user_app/features/cart/presentation/widgets/checkout/delivery_address_section.dart';
import 'package:food_user_app/features/cart/presentation/widgets/checkout/place_order_button.dart';
import 'package:food_user_app/features/profile/screens/order/order_history.dart';

class CheckoutScreen extends StatefulWidget {
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
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = "cod";
  late CheckoutController controller;

  @override
  void initState() {
    super.initState();
    controller = CheckoutController(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) async {
        if (state is CheckoutSuccess) {
          await controller.afterOrderSuccess();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Order Placed Successfully")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrderHistory()),
          );
        } else if (state is CheckoutFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("❌ Failed: ${state.message}")));
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
                      const Divider(height: 30),

                      PaymentMethodSelector(
                        selectedPayment: _selectedPayment,
                        onChanged: (value) {
                          setState(() => _selectedPayment = value);
                        },
                      ),

                      PriceSummary(
                        subtotal: widget.subtotal,
                        discount: widget.discount,
                        delivery: widget.deliveryFee,
                        total: widget.total,
                      ),

                      const SizedBox(height: 30),

                      PlaceOrderButton(
                        subtotal: widget.subtotal,
                        discount: widget.discount,
                        total: widget.total,
                        controller: controller,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
