import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_user_app/core/services/payment_function.dart';
import 'package:food_user_app/core/constant/payment_key.dart';

class PaymentService {
  Future<String> makePayment(int amount) async {
    try {
      final result = await _paymentInit(amount);
      if (result == null) throw Exception("Payment init failed");

      String paymentId = result["paymentId"]!;
      String clientSecret = result["clientSecret"]!;
      await _paymentUiSheet(clientSecret);

      return paymentId;
    } catch (e) {
      log("Payment Error: $e");
      rethrow;
    }
  }

  Future<Map<String, String>?> _paymentInit(int amount) async {
    Dio dio = Dio();
    final data = {"amount": convertAmount(amount), "currency": "INR"};

    final response = await dio.post(
      "https://api.stripe.com/v1/payment_intents",
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );

    return {
      "paymentId": response.data["id"],
      "clientSecret": response.data["client_secret"],
    };
  }

  Future<void> _paymentUiSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: "Your Hotel Name",
        paymentIntentClientSecret: clientSecret,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }
}
