import 'package:flutter/material.dart';

class FoodImagesWidget extends StatelessWidget {
  final List<dynamic> foodImages;
  const FoodImagesWidget({super.key, required this.foodImages});

  @override
  Widget build(BuildContext context) {
    // ✅ Fixed: safe access, handles 0, 1, or 2+ images
    final validImages = foodImages
        .map((e) => e?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .take(2)
        .toList();

    if (validImages.isEmpty) {
      return _buildPlaceholder();
    }

    if (validImages.length == 1) {
      return _buildImage(validImages[0]);
    }

    return SizedBox(
      width: 90,
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 0, child: _buildImage(validImages[0])),
          Positioned(left: 20, top: 10, child: _buildImage(validImages[1])),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 60,
        height: 60,
        color: Colors.white24,
        child: const Icon(Icons.fastfood, color: Colors.white54, size: 28),
      ),
    );
  }
}
