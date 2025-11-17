import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/cart/data/services/cart_services.dart';
import 'package:food_user_app/features/cart/logic/cubit/cart/drink_selection_cubit.dart';

class CoolDrinksBottomSheet extends StatelessWidget {
  const CoolDrinksBottomSheet({super.key});

  Map<String, dynamic> _docSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return {
      'id': doc.id,
      'name': data['name'] ?? '',
      'price': (data['price'] ?? 0).toDouble(),
      'imageUrl': data['imageUrl'] ?? '',
      'category': data['category'] ?? '',
      'description': data['description'] ?? '',
      'quantity': 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Cubit is now provided by parent (main screen)
    final cubit = context.read<DrinkSelectionCubit>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Select Drinks",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("FoodItems")
                  .where("category", whereIn: ["Cool Drinks", "Chai & Coffee"])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No drinks available right now!"),
                  );
                }

                final drinks = snapshot.data!.docs;

                return BlocBuilder<
                  DrinkSelectionCubit,
                  List<Map<String, dynamic>>
                >(
                  builder: (context, selectedDrinks) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: drinks.length,
                      itemBuilder: (context, index) {
                        final itemData = _docSnapshot(drinks[index]);
                        final name = itemData['name'];
                        final imageUrl = itemData['imageUrl'];
                        final isSelected = cubit.isSelected(itemData['id']);

                        return InkWell(
                          onTap: () => cubit.toggleSelection(itemData),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primaryOrange
                                            : AppColors.primaryOrange
                                                  .withOpacity(0.15),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.fill,
                                              errorBuilder:
                                                  (ctx, error, stack) =>
                                                      const Icon(
                                                        Icons.broken_image,
                                                        size: 30,
                                                      ),
                                            )
                                          : const Icon(Icons.image, size: 30),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Positioned(
                                      right: 4,
                                      bottom: 4,
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.green,
                                        child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: BlocBuilder<DrinkSelectionCubit, List<Map<String, dynamic>>>(
              builder: (context, selectedDrinks) {
                final hasSelection = selectedDrinks.isNotEmpty;
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasSelection
                          ? AppColors.primaryOrange
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      if (hasSelection) {
                        CartServices.addMultipleToCart(context, selectedDrinks);
                        cubit.clearSelection(); // ✅ clear after adding
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      hasSelection ? "Add to Cart" : "Cancel",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
