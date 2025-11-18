import 'package:flutter/material.dart';

class PriceSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double delivery;
  final double total;

  const PriceSummary({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30),

        PriceRow(title: "Subtotal", value: "₹${subtotal.toStringAsFixed(2)}"),
        PriceRow(title: "Discount", value: "₹${discount.toStringAsFixed(2)}"),
        PriceRow(title: "Delivery", value: "₹${delivery.toStringAsFixed(2)}"),

        const Divider(thickness: 1),

        PriceRow(
          title: "Total",
          value: "₹${total.toStringAsFixed(2)}",
          isBold: true,
          fontSize: 20,
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}

class PriceRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  final double fontSize;

  const PriceRow({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
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
}
