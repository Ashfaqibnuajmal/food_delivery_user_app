import 'package:flutter/material.dart';
import 'package:food_user_app/features/order/presentation/screen/order_history_screen.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
          );
        },
        child: const ListTile(
          leading: Icon(Icons.history, color: Colors.black),
          title: Text(
            "Order History",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
