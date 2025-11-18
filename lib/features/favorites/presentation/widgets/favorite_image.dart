import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteImage extends StatelessWidget {
  final String imageUrl;

  const FavoriteImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.fill,

              // Shimmer while loading
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(width: 80, height: 80, color: Colors.white),
                );
              },

              // Error widget
              errorBuilder: (context, error, stackTrace) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            )
          // No URL → placeholder
          : Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
    );
  }
}
