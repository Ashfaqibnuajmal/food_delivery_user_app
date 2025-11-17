import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar_action.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:food_user_app/features/profile/screens/chat/chat_and_support.dart';
import 'package:food_user_app/features/profile/services/order_serivices.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {"title": "Making", "icon": Icons.restaurant},
      {"title": "Packing", "icon": Icons.inventory},
      {"title": "Out for Delivery", "icon": Icons.delivery_dining},
      {"title": "Delivered", "icon": Icons.check_circle},
    ];

    Widget buildStep(
      Map<String, Object> step, {
      required bool isLast,
      bool isActive = false,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primaryOrange : Colors.black,
                    width: 2,
                  ),
                  color: isActive
                      ? AppColors.primaryOrange.withOpacity(0.1)
                      : null,
                ),
                child: Icon(
                  step["icon"] as IconData,
                  size: 16,
                  color: Colors.black,
                ),
              ),
              if (!isLast)
                Container(
                  height: 40,
                  width: 2,
                  color: isActive ? AppColors.primaryOrange : Colors.black,
                ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step["title"] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                step["time"] as String,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      );
    }

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
              unselectedLabelColor: AppColors.primaryOrange,
              indicatorColor: AppColors.primaryOrange,
              tabs: [
                Tab(text: 'Ongoing'),
                Tab(text: 'Completed'),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: OrderServices.getAllOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 180),
                        Image.asset(
                          "assets/OrderEmpty.png",
                          height: 150,
                          width: 150,
                        ),
                        const Text(
                          "No History Yet!",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final ordersItems = snapshot.data!.docs;
                final data = ordersItems.first.data() as Map<String, dynamic>;

                final orderId = data['orderId'] ?? 'N/A';
                final currentStatus = (data['orderStatus'] ?? 'Making')
                    .toString();

                int activeIndex = steps.indexWhere(
                  (s) => s['title'] == currentStatus,
                );
                if (activeIndex == -1) activeIndex = 0;

                // ✅ Handle timestamps safely
                final createdRaw = data['createdAt'];

                final createdTs = OrderServices.safeToTimestamp(createdRaw);
                final createdText = OrderServices.formatDate(createdTs);
                Text(OrderServices.formatOrderId(orderId));

                final rawMap = data['statusTimestamps'];
                final Map<String, dynamic> statusMap = (rawMap is Map)
                    ? Map<String, dynamic>.from(rawMap)
                    : {};

                // ✅ Generate simulated times (+5 min each)
                List<String> simulatedTimes = [];
                if (createdTs != null) {
                  DateTime baseTime = createdTs.toDate();
                  for (int i = 0; i < steps.length; i++) {
                    String title = steps[i]['title'] as String;
                    Timestamp? ts = OrderServices.safeToTimestamp(
                      statusMap[title],
                    );
                    if (ts != null) {
                      simulatedTimes.add(OrderServices.formatDate(ts));
                      baseTime = ts.toDate(); // reset base for next step
                    } else {
                      // Add 5 minutes more than previous
                      baseTime = baseTime.add(const Duration(minutes: 5));
                      simulatedTimes.add(
                        DateFormat('MMM d, yyyy - hh:mm a').format(baseTime),
                      );
                    }
                  }
                }

                return Expanded(
                  child: TabBarView(
                    children: [
                      // ---------------- O N G O I N G ----------------
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Order ID",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              OrderServices.formatOrderId(orderId),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 20),
                            Text(
                              currentStatus,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Placed on $createdText",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ✅ Dynamic Timeline with simulated time
                            Column(
                              children: List.generate(steps.length, (i) {
                                final step = steps[i];
                                final icon = step['icon'] as IconData;
                                final title = step['title'] as String;
                                final isLast = i == steps.length - 1;
                                final isActive = i <= activeIndex;

                                final map = {
                                  "icon": icon,
                                  "title": title,
                                  "time": simulatedTimes[i],
                                };

                                return buildStep(
                                  map,
                                  isLast: isLast,
                                  isActive: isActive,
                                );
                              }),
                            ),
                            const SizedBox(height: 24),

                            // Stacked images + text card
                            Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        left: 0,
                                        child: Image.asset(
                                          "assets/intro_image1.jpeg",
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                ),
                                              ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        top: 10,
                                        child: Image.asset(
                                          'assets/intro_image1.jpeg',
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const SizedBox(
                                                width: 70,
                                                height: 70,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                ),
                                              ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/intro_image1.jpeg',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const SizedBox(
                                              width: 70,
                                              height: 70,
                                              child: Icon(
                                                Icons.image_not_supported,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 40),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Chicken Biriyani, Beef Roast, Chicken Chilli, Pepsi",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Home\nKunnamkulam, Thrissur, Kerala",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ChatAndSupport(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 60,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.call, color: Colors.black),
                                      SizedBox(width: 8),
                                      Text(
                                        "Need Help?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ---------------- C O M P L E T E D ----------------
                      ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 60,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'assets/intro_image1.jpeg',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 30,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'assets/intro_image1.jpeg',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 60,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'assets/intro_image1.jpeg',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Biriyani',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'July 24   8:50am',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '₹ 120',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Bottom row: Completed chip + Re-Order button
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: AppColors.primaryOrange,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Completed',
                                              style: TextStyle(
                                                color: AppColors.primaryOrange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .shopping_cart_outlined,
                                                      size: 40,
                                                      color: AppColors
                                                          .primaryOrange,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    const Text(
                                                      "Go to cart?",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    const Text(
                                                      "Do you really want to continue this action?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                ),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey[400],
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Text(
                                                                "No",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primaryOrange,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryOrange,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Re Order',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:mera_app/core/theme/app_color.dart';
// import 'package:mera_app/features/profile/screens/chat/chat_and_support.dart';

// class OrderHistory extends StatelessWidget {
//   const OrderHistory({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final steps = [
//       {"icon": Icons.restaurant, "title": "Making", "time": "July 29 10:30AM"},
//       {"icon": Icons.inventory, "title": "Packing", "time": "July 29 10:35AM"},
//       {
//         "icon": Icons.delivery_dining,
//         "title": "Out Of Delivery",
//         "time": "July 29 10:40AM"
//       },
//       {
//         "icon": Icons.check_circle,
//         "title": "Delivered",
//         "time": "July 29 10:45AM"
//       },
//     ];

//     Widget buildStep(Map<String, Object> step, {required bool isLast}) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.black, width: 2),
//                 ),
//                 child: Icon(step["icon"] as IconData,
//                     size: 16, color: Colors.black),
//               ),
//               if (!isLast)
//                 Container(
//                   height: 40,
//                   width: 2,
//                   color: Colors.black,
//                 ),
//             ],
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 step["title"] as String,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 step["time"] as String,
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: const Text(
//           'Order History',
//           style: TextStyle(
//               color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: DefaultTabController(
//         length: 2,
//         child: Column(
//           children: [
//             TabBar(
//               labelColor: AppColors.primaryOrange,
//               unselectedLabelColor: AppColors.primaryOrange,
//               indicatorColor: AppColors.primaryOrange,
//               tabs: const [Tab(text: 'Ongoing'), Tab(text: 'Completed')],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   // ---------------- O N G O I N G ----------------
//                   SingleChildScrollView(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("Order ID",
//                             style: TextStyle(color: Colors.grey)),
//                         const SizedBox(height: 2),
//                         const Text("#12345",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500)),
//                         const SizedBox(height: 20),
//                         const Text("Ongoing",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.w800)),
//                         const SizedBox(height: 4),
//                         const Text(
//                           "Expected delivery, Today 2:00 PM – 2:30 PM",
//                           style: TextStyle(color: Colors.grey, fontSize: 12),
//                         ),
//                         const SizedBox(height: 20),

//                         // Timeline
//                         Column(
//                           children: List.generate(
//                             steps.length,
//                             (i) => buildStep(steps[i],
//                                 isLast: i == steps.length - 1),
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Stacked images + text card
//                         Container(
//                           margin: const EdgeInsets.all(4),
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryOrange,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 6,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     left: 0,
//                                     child: Image.asset(
//                                       "assets/intro_image1.jpeg",
//                                       width: 70,
//                                       height: 70,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (_, __, ___) =>
//                                           const SizedBox(
//                                         width: 70,
//                                         height: 70,
//                                         child: Icon(Icons.image_not_supported),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     left: 10,
//                                     top: 10,
//                                     child: Image.asset(
//                                       'assets/intro_image1.jpeg',
//                                       width: 70,
//                                       height: 70,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (_, __, ___) =>
//                                           const SizedBox(
//                                         width: 70,
//                                         height: 70,
//                                         child: Icon(Icons.image_not_supported),
//                                       ),
//                                     ),
//                                   ),
//                                   Image.asset(
//                                     'assets/intro_image1.jpeg',
//                                     width: 70,
//                                     height: 70,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (_, __, ___) =>
//                                         const SizedBox(
//                                       width: 70,
//                                       height: 70,
//                                       child: Icon(Icons.image_not_supported),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(width: 40),
//                               const Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Chicken Biriyani, Beef Roast, Chicken Chilli, Pepsi",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       "Home\nKunnamkulam, Thrissur, Kerala",
//                                       style: TextStyle(fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         Center(
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const ChatAndSupport()));
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 60, vertical: 10),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30),
//                                 border:
//                                     Border.all(color: Colors.black, width: 0.5),
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.call, color: Colors.black),
//                                   SizedBox(width: 8),
//                                   Text(
//                                     "Need Help?",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),

//                   // ---------------- C O M P L E T E D ----------------
//                   ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: 3,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: 80,
//                                   height: 60,
//                                   child: Stack(
//                                     children: [
//                                       Positioned(
//                                         left: 0,
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.asset(
//                                             'assets/intro_image1.jpeg',
//                                             width: 50,
//                                             height: 50,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (_, __, ___) =>
//                                                 const SizedBox(
//                                               width: 70,
//                                               height: 70,
//                                               child: Icon(
//                                                   Icons.image_not_supported),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         left: 30,
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.asset(
//                                             'assets/intro_image1.jpeg',
//                                             width: 50,
//                                             height: 50,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (_, __, ___) =>
//                                                 const SizedBox(
//                                               width: 70,
//                                               height: 70,
//                                               child: Icon(
//                                                   Icons.image_not_supported),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         left: 60,
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.asset(
//                                             'assets/intro_image1.jpeg',
//                                             width: 50,
//                                             height: 50,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (_, __, ___) =>
//                                                 const SizedBox(
//                                               width: 70,
//                                               height: 70,
//                                               child: Icon(
//                                                   Icons.image_not_supported),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 const Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Biriyani',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold)),
//                                       SizedBox(height: 4),
//                                       Text('July 24   8:50am',
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey)),
//                                       SizedBox(height: 4),
//                                       Text('₹ 120',
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500)),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 12),

//                             // Bottom row: Completed chip + Re-Order button
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.orange.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: const Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.check_circle_outline_rounded,
//                                             color: AppColors.primaryOrange,
//                                             size: 18),
//                                         SizedBox(width: 5),
//                                         Text('Completed',
//                                             style: TextStyle(
//                                                 color:
//                                                     AppColors.primaryOrange)),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             backgroundColor: Colors.white,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                             ),
//                                             content: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 const Icon(
//                                                     Icons
//                                                         .shopping_cart_outlined,
//                                                     size: 40,
//                                                     color: AppColors
//                                                         .primaryOrange),
//                                                 const SizedBox(height: 10),
//                                                 const Text("Go to cart?",
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         fontSize: 18)),
//                                                 const SizedBox(height: 6),
//                                                 const Text(
//                                                   "Do you really want to continue this action?",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color: Colors.grey),
//                                                 ),
//                                                 const SizedBox(height: 20),
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                       child: GestureDetector(
//                                                         onTap: () =>
//                                                             Navigator.pop(
//                                                                 context),
//                                                         child: Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical: 10),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: Colors
//                                                                 .grey[400],
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         8),
//                                                           ),
//                                                           alignment:
//                                                               Alignment.center,
//                                                           child: const Text(
//                                                             "No",
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     const SizedBox(width: 12),
//                                                     Expanded(
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         child: Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical: 10),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: AppColors
//                                                                 .primaryOrange,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         8),
//                                                           ),
//                                                           alignment:
//                                                               Alignment.center,
//                                                           child: const Text(
//                                                             "Yes",
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 10),
//                                       decoration: BoxDecoration(
//                                         color: AppColors.primaryOrange,
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: const Center(
//                                         child: Text('Re Order',
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w500)),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
