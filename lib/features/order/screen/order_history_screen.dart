import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar_action.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/order/widgets/completed/complete_order_card.dart';
import 'package:food_user_app/features/order/services/history_service.dart';
import 'package:food_user_app/features/order/widgets/ongoing/ongoing_order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Order History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [CustomAppBarActions(showChatBot: false)],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: AppColors.primaryOrange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryOrange,
              tabs: [
                Tab(text: 'Ongoing'),
                Tab(text: 'Completed'),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: HistoryService.getAllOrdersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingIndicator());
                  }

                  final allDocs = snapshot.data?.docs ?? [];

                  final ongoingOrders = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final status = data['orderStatus'] ?? '';
                    return status == 'Making' ||
                        status == 'Packing' ||
                        status == 'Out for Delivery';
                  }).toList();

                  final completedOrders = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return (data['orderStatus'] ?? '') == 'Delivered';
                  }).toList();

                  return TabBarView(
                    children: [
                      // ── ONGOING ──
                      ongoingOrders.isEmpty
                          ? _buildEmptyState('No ongoing orders')
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: ongoingOrders.length,
                              itemBuilder: (context, index) {
                                final data =
                                    ongoingOrders[index].data()
                                        as Map<String, dynamic>;
                                return OngoingOrderCard(orderData: data);
                              },
                            ),

                      // ── COMPLETED ──
                      completedOrders.isEmpty
                          ? _buildEmptyState('No completed orders yet')
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: completedOrders.length,
                              itemBuilder: (context, index) {
                                return const CompletedOrderCard();
                              },
                            ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/OrderEmpty.png', height: 150, width: 150),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
