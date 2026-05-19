import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ShimmerLayoutType { grid, list, card, category, horizontal }

class ShimmerLoader extends StatelessWidget {
  final ShimmerLayoutType type;
  final int itemCount;

  const ShimmerLoader({
    super.key,
    this.type = ShimmerLayoutType.list,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ShimmerLayoutType.grid:
        return _buildGrid();
      case ShimmerLayoutType.list:
        return _buildList();
      case ShimmerLayoutType.card:
        return _buildSingleCard();
      case ShimmerLayoutType.category:
        return _buildCategory();
      case ShimmerLayoutType.horizontal:
        return _buildHorizontal();
    }
  }

  // ─────────────────────────────────────────
  // 🔹 GRID — for food grid screens
  // ─────────────────────────────────────────
  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 30, bottom: 8, left: 8, right: 8),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (_, __) => _shimmerWrap(_gridCard()),
    );
  }

  Widget _gridCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [_circle(12), const SizedBox(width: 5), _line(35, 10)]),
          const SizedBox(height: 10),
          Center(child: _rounded(95, 95, 20)),
          const SizedBox(height: 12),
          _line(double.infinity, 11),
          const SizedBox(height: 6),
          _line(80, 11),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(28, 8),
                  const SizedBox(height: 4),
                  _line(48, 13),
                ],
              ),
              _circle(34),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 🔹 LIST — for order history, notifications
  // ─────────────────────────────────────────
  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => _shimmerWrap(_listTile()),
    );
  }

  Widget _listTile() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _rounded(60, 60, 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(double.infinity, 13),
                const SizedBox(height: 8),
                _line(120, 10),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _circle(10),
                    const SizedBox(width: 4),
                    _line(50, 9),
                    const SizedBox(width: 12),
                    _line(40, 9),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _line(45, 13),
              const SizedBox(height: 8),
              _rounded(28, 28, 8),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 🔹 CARD — single detail card / food detail page
  // ─────────────────────────────────────────
  Widget _buildSingleCard() {
    return _shimmerWrap(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rounded(double.infinity, 200, 20),
            const SizedBox(height: 16),
            _line(200, 20),
            const SizedBox(height: 10),
            _line(double.infinity, 12),
            const SizedBox(height: 6),
            _line(double.infinity, 12),
            const SizedBox(height: 6),
            _line(160, 12),
            const SizedBox(height: 20),
            Row(
              children: [
                _circle(14),
                const SizedBox(width: 6),
                _line(60, 12),
                const SizedBox(width: 16),
                _circle(14),
                const SizedBox(width: 6),
                _line(50, 12),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(40, 10),
                    const SizedBox(height: 4),
                    _line(70, 18),
                  ],
                ),
                _rounded(120, 44, 22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // 🔹 CATEGORY — horizontal category chips
  // ─────────────────────────────────────────
  Widget _buildCategory() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _shimmerWrap(
            Column(
              children: [_circle(70), const SizedBox(height: 6), _line(50, 10)],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // 🔹 HORIZONTAL — for "best combo" sections
  // ─────────────────────────────────────────
  Widget _buildHorizontal() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _shimmerWrap(
            Container(
              width: 140,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _rounded(90, 90, 14)),
                  const SizedBox(height: 10),
                  _line(double.infinity, 11),
                  const SizedBox(height: 6),
                  _line(70, 10),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_line(40, 12), _circle(26)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // 🔧 HELPERS
  // ─────────────────────────────────────────
  Widget _shimmerWrap(Widget child) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }

  Widget _line(double width, double height) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _rounded(double width, double height, double radius) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
