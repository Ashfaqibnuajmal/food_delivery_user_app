// class AddressScreen extends StatelessWidget {
//   const AddressScreen({super.key});

//   void _showDeleteDialog(BuildContext context, String id) {
//     showDialog(
//       context: context,
//       builder: (ctx) => Dialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFE53E3E),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.question_mark, color: Colors.white),
//               ),
//               const SizedBox(height: 16),
//               const Text('Delete address?'),
//               const SizedBox(height: 12),
//               const Text(
//                 'Are you sure you want to delete\nthis address?',
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       child: const Text('NO'),
//                     ),
//                   ),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         context.read<AddressCubit>().removeAddress(id);
//                         Navigator.pop(ctx);
//                       },
//                       child: const Text('YES'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<AddressCubit>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(title: "Address"),
//       body: BlocBuilder<AddressCubit, List<AddressModel>>(
//         builder: (context, addresses) {
//           return Column(
//             children: [
//               Expanded(
//                 child: addresses.isEmpty
//                     ? const Center(child: Text("No saved addresses"))
//                     : ListView.separated(
//                         padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
//                         itemCount: addresses.length,
//                         separatorBuilder: (_, __) => const SizedBox(height: 12),
//                         itemBuilder: (context, index) {
//                           final addr = addresses[index];
//                           final isSelected =
//                               cubit.selectedAddress?.id == addr.id;

//                           return GestureDetector(
//                             onTap: () {
//                               if (isSelected) {
//                                 cubit.selectAddress(null);
//                               } else {
//                                 cubit.selectAddress(addr);
//                               }
//                             },
//                             onLongPress: () =>
//                                 _showDeleteDialog(context, addr.id),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 200),
//                               padding: const EdgeInsets.all(14),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(14),
//                                 border: Border.all(
//                                   color: isSelected
//                                       ? AppColors.primaryOrange
//                                       : Colors.grey.shade200,
//                                   width: isSelected ? 1.5 : 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.location_on_outlined,
//                                     color: isSelected
//                                         ? AppColors.primaryOrange
//                                         : Colors.grey,
//                                   ),
//                                   const SizedBox(width: 12),

//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           addr.label,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(addr.street),
//                                         const SizedBox(height: 2),
//                                         Text(addr.phone),
//                                       ],
//                                     ),
//                                   ),

//                                   if (isSelected)
//                                     const Icon(
//                                       Icons.check_circle,
//                                       color: AppColors.primaryOrange,
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),

//               /// Bottom
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     OutlinedButton(
//                       onPressed: () async {
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => BlocProvider.value(
//                               value: cubit,
//                               child: const AddAddressScreen(),
//                             ),
//                           ),
//                         );

//                         cubit.loadAddresses();
//                       },
//                       child: const Text("Add New Address"),
//                     ),
//                     const SizedBox(height: 10),

//                     ElevatedButton(
//                       onPressed: cubit.selectedAddress == null
//                           ? null
//                           : () => Navigator.pop(context, cubit.selectedAddress),
//                       child: const Text("Apply"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
