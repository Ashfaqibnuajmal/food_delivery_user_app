// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:food_user_app/core/theme/app_color.dart';

// class ChatAndSupport extends StatefulWidget {
//   final String userId; // Current user ID

//   const ChatAndSupport({super.key, required this.userId});

//   @override
//   State<ChatAndSupport> createState() => _ChatAndSupportState();
// }

// class _ChatAndSupportState extends State<ChatAndSupport> {
//   final TextEditingController _messageController = TextEditingController();

//   final String adminId = "ADMIN_HOTEL_001"; // Admin ID

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back_ios,
//                       size: 30,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Chat &",
//                         style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 25,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(
//                         "Support",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 25,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Messages List
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Chats")
//                     .doc(widget.userId) // user chat doc
//                     .collection("messages")
//                     .orderBy("timestamp", descending: false)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.primaryOrange,
//                       ),
//                     );
//                   }

//                   final docs = snapshot.data!.docs;

//                   if (docs.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         "No messages yet. Start chatting with admin!",
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     );
//                   }

//                   return ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: docs.length,
//                     itemBuilder: (context, index) {
//                       final data = docs[index].data() as Map<String, dynamic>;

//                       // Check if the sender is user or admin
//                       final isUser = data['senderId'] == widget.userId;

//                       return Align(
//                         alignment: isUser
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           padding: const EdgeInsets.all(12.0),
//                           decoration: BoxDecoration(
//                             color: isUser
//                                 ? AppColors.primaryOrange
//                                 : Colors.grey[200],
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: const Radius.circular(16),
//                               bottomRight: const Radius.circular(16),
//                               topLeft: isUser
//                                   ? const Radius.circular(16)
//                                   : const Radius.circular(0),
//                               topRight: isUser
//                                   ? const Radius.circular(0)
//                                   : const Radius.circular(16),
//                             ),
//                           ),
//                           child: Text(
//                             data['message'] ?? "",
//                             style: TextStyle(
//                               color: isUser ? Colors.white : Colors.black,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),

//             // Input Field
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextField(
//                         controller: _messageController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type something...',
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: AppColors.primaryOrange,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.send, color: Colors.white),
//                       onPressed: () async {
//                         if (_messageController.text.trim().isEmpty) return;

//                         // Add user message to same chat doc
//                         await FirebaseFirestore.instance
//                             .collection("Chats")
//                             .doc(widget.userId)
//                             .collection("messages")
//                             .add({
//                               "message": _messageController.text.trim(),
//                               "senderId": widget.userId,
//                               "receiverId": adminId,
//                               "timestamp": DateTime.now(),
//                               "isRead": false,
//                             });

//                         _messageController.clear();
//                       },
//                     ),
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
