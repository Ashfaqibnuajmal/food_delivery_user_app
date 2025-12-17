import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/category/food_category_filter_cubit.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:shimmer/shimmer.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Category').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No categories found"));
          }

          final categories = snapshot.data!.docs;

          return BlocBuilder<FoodCategoryFilterCubit, String?>(
            builder: (context, selectedCategory) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final data = categories[index].data() as Map<String, dynamic>;
                  final name = data['name'] ?? 'No Name';

                  // Support both imageUrls (list) and imageUrl (single) for backward compatibility
                  List<String> imageUrls = [];
                  if (data['imageUrls'] != null && data['imageUrls'] is List) {
                    imageUrls = List<String>.from(data['imageUrls']);
                  } else if (data['imageUrl'] != null &&
                      data['imageUrl'].toString().isNotEmpty) {
                    imageUrls = [data['imageUrl']];
                  }

                  final isSelected = selectedCategory == name;

                  return CategoryItem(
                    name: name,
                    imageUrls: imageUrls,
                    isSelected: isSelected,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String name;
  final List<String> imageUrls;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.name,
    required this.imageUrls,
    required this.isSelected,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  int _currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startImageRotation() {
    // Only start timer if there are multiple images
    if (widget.imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (mounted) {
          setState(() {
            _currentImageIndex =
                (_currentImageIndex + 1) % widget.imageUrls.length;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              final cubit = context.read<FoodCategoryFilterCubit>();
              if (widget.isSelected) {
                cubit.clearCategory();
              } else {
                cubit.selectCategory(widget.name);
              }
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isSelected
                      ? AppColors.primaryOrange
                      : AppColors.primaryOrange.withOpacity(0.1),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: widget.imageUrls.isNotEmpty
                    ? Image.network(
                        widget.imageUrls[_currentImageIndex],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // ✅ Image loaded
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 70,
                              height: 70,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (ctx, error, stack) => const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(widget.name, style: smallBold, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
