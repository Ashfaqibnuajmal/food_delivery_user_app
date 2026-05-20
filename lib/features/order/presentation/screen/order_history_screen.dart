import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/shimmer_food_grid.dart';
import 'package:food_user_app/features/order/presentation/widgets/completed/complete_order_card.dart';
import 'package:food_user_app/features/order/presentation/widgets/ongoing/need_help_button.dart';
import 'package:food_user_app/features/order/presentation/widgets/ongoing/ongoing_order_card.dart';
import 'package:food_user_app/features/order/services/history_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: "Order History", showBack: false),

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
                    return const Center(
                      child: ShimmerLoader(type: ShimmerLayoutType.card),
                    );
                  }

                  final allDocs = snapshot.data?.docs ?? [];

                  // SORT BY LATEST
                  allDocs.sort((a, b) {
                    final aData = a.data() as Map<String, dynamic>;

                    final bData = b.data() as Map<String, dynamic>;

                    final aTs = HistoryService.safeToTimestamp(
                      aData['createdAt'],
                    );

                    final bTs = HistoryService.safeToTimestamp(
                      bData['createdAt'],
                    );

                    if (aTs == null || bTs == null) {
                      return 0;
                    }

                    return bTs.compareTo(aTs);
                  });

                  // ONGOING
                  final ongoingOrders = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final status = data['orderStatus'] ?? '';

                    return status == 'Making' ||
                        status == 'Packing' ||
                        status == 'Out for Delivery';
                  }).toList();

                  // COMPLETED
                  final completedOrders = allDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return (data['orderStatus'] ?? '') == 'Delivered';
                  }).toList();

                  return TabBarView(
                    children: [
                      ongoingOrders.isEmpty
                          ? _buildEmptyState('No ongoing orders')
                          : ListView(
                              padding: const EdgeInsets.all(20),

                              children: [
                                ...ongoingOrders.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;

                                  return OngoingOrderCard(orderData: data);
                                }),

                                const NeedHelpButton(),

                                const SizedBox(height: 10),
                              ],
                            ),

                      completedOrders.isEmpty
                          ? _buildEmptyState('No completed orders yet')
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),

                              itemCount: completedOrders.length,

                              itemBuilder: (context, index) {
                                final data =
                                    completedOrders[index].data()
                                        as Map<String, dynamic>;

                                return CompletedOrderCard(orderData: data);
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
