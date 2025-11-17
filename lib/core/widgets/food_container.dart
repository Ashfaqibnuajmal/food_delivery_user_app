import 'package:flutter/material.dart';

class CustomStyledContainer extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const CustomStyledContainer({
    super.key,
    this.padding = const EdgeInsets.all(0),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
