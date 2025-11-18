import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_bloc.dart';
import 'package:food_user_app/features/cart/logic/bloc/cart_event.dart';
import 'package:food_user_app/features/cart/logic/cubit/checkout/checkout_cubit.dart';
import 'package:food_user_app/features/cart/logic/cubit/location/location_cubit.dart';
import 'package:food_user_app/features/cart/logic/cubit/location/location_state.dart';
import 'package:food_user_app/features/cart/presentation/screens/address_screen.dart';
import 'package:food_user_app/features/profile/screens/order/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) async {
        if (state is CheckoutSuccess) {
          // 🧹 Clear cart
          context.read<CartBloc>().add(ClearCart());

          // 🔁 Reset the Cool Drink bottom sheet flag
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('coolDrinkBottomSheetShown');

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Order Placed Successfully")),
          );

          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
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
        final cubit = context.read<CheckoutCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            ),
          ),
          body: state is CheckoutLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: BlocBuilder<LocationCubit, LocationState>(
                          builder: (context, state) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // HEADER
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Delivery Address",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    if (state is LocationLoaded)
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.grey,
                                            decorationThickness: 1.5,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(1, 1),
                                                blurRadius: 2,
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                if (state is LocationLoading)
                                  const Center(child: LoadingIndicator())
                                else if (state is LocationLoaded)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Home",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40,
                                        ),
                                        child: Text(
                                          state.address,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else if (state is LocationError)
                                  Center(
                                    child: Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          child: Image.asset(
                                            'assets/location.jpeg',
                                            height: 200,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            context
                                                .read<LocationCubit>()
                                                .getCurrentLocation();
                                          },
                                          icon: const Icon(
                                            Icons.my_location,
                                            size: 20,
                                          ),
                                          label: const Text(
                                            "Add Current Location",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            side: const BorderSide(
                                              color: Colors.black,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            minimumSize: const Size(250, 50),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),

                      const Divider(height: 30),

                      // 🔹 Payment Method
                      const Text(
                        "Payment Method",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      RadioListTile<String>(
                        value: "cod",
                        groupValue: _selectedPayment,
                        activeColor: AppColors.primaryOrange,
                        onChanged: (value) {
                          setState(() => _selectedPayment = value!);
                        },
                        title: const Text("Cash On Delivery"),
                      ),
                      RadioListTile<String>(
                        value: "razorpay",
                        activeColor: AppColors.primaryOrange,
                        groupValue: _selectedPayment,
                        onChanged: (value) {
                          setState(() => _selectedPayment = value!);
                        },
                        title: const Text("Razorpay"),
                      ),
                      const Divider(height: 30),

                      // 🔹 Price Summary
                      _priceRow(
                        "Subtotal",
                        "₹${widget.subtotal.toStringAsFixed(2)}",
                      ),
                      _priceRow(
                        "Discount",
                        "₹${widget.discount.toStringAsFixed(2)}",
                      ),
                      _priceRow(
                        "Delivery",
                        "₹${widget.deliveryFee.toStringAsFixed(2)}",
                      ),
                      const Divider(thickness: 1),
                      _priceRow(
                        "Total",
                        "₹${widget.total.toStringAsFixed(2)}",
                        isBold: true,
                        fontSize: 20,
                      ),
                      const SizedBox(height: 30),

                      // 🔹 Place Order Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: AppColors.primaryOrange,
                          ),
                          onPressed: () {
                            cubit.placeOrder(
                              subtotal: widget.subtotal,
                              discount: widget.discount,
                              total: widget.total,
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Place Order",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

Widget _priceRow(
  String title,
  String value, {
  bool isBold = false,
  double fontSize = 15,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
