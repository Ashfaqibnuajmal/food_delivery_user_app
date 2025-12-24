import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/category/category_image_rotation_cubit.dart';
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

                  List<String> imageUrls = [];
                  if (data['imageUrls'] != null && data['imageUrls'] is List) {
                    imageUrls = List<String>.from(data['imageUrls']);
                  } else if (data['imageUrl'] != null &&
                      data['imageUrl'].toString().isNotEmpty) {
                    imageUrls = [data['imageUrl']];
                  }

                  return BlocProvider(
                    create: (_) => CategoryImageRotationCubit(
                      imageCount: imageUrls.length,
                    ),
                    child: CategoryItem(
                      name: name,
                      imageUrls: imageUrls,
                      isSelected: selectedCategory == name,
                    ),
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

class CategoryItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              final cubit = context.read<FoodCategoryFilterCubit>();
              if (isSelected) {
                cubit.clearCategory();
              } else {
                cubit.selectCategory(name);
              }
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryOrange
                      : AppColors.primaryOrange.withOpacity(0.1),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: BlocBuilder<CategoryImageRotationCubit, int>(
                  builder: (context, index) {
                    if (imageUrls.isEmpty) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    }

                    return Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
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
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(name, style: smallBold, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
