import 'package:flutter/material.dart';

class CompletedOrderImageStack extends StatelessWidget {
  const CompletedOrderImageStack({super.key, required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    const imgSize = 64.0;

    /// EMPTY IMAGE
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),

        child: Container(
          width: imgSize,
          height: imgSize,
          color: Colors.grey.shade100,

          child: Icon(
            Icons.fastfood_rounded,
            color: Colors.grey.shade400,
            size: 28,
          ),
        ),
      );
    }

    /// SINGLE IMAGE
    if (images.length == 1) {
      return _buildSingleImage(images[0], imgSize);
    }

    /// MULTIPLE IMAGES
    return SizedBox(
      width: imgSize + 10,
      height: imgSize + 10,

      child: Stack(
        children: [
          /// BACK IMAGE
          Positioned(
            left: 0,
            top: 10,

            child: _buildSingleImage(images[1], imgSize, opacity: 0.75),
          ),

          /// FRONT IMAGE
          Positioned(
            left: 10,
            top: 0,

            child: _buildSingleImage(images[0], imgSize),
          ),
        ],
      ),
    );
  }

  /// ======================================================
  /// SINGLE IMAGE
  /// ======================================================

  Widget _buildSingleImage(String url, double size, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: Colors.white, width: 2),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,

            errorBuilder: (_, __, ___) => Container(
              width: size,
              height: size,
              color: Colors.grey.shade100,

              child: Icon(
                Icons.image_not_supported_outlined,
                size: 22,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
