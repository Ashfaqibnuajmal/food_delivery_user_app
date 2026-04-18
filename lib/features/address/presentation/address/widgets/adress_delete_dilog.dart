import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class DeleteAddressDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAddressDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFE53E3E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.question_mark,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            const Text('Delete address?', style: bigBold),
            const SizedBox(height: 12),

            const Text(
              'Are you sure you want to delete\nthis address?',
              textAlign: TextAlign.center,
              style: greySmallTextStyle,
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E5E5),
                    ),
                    child: const Text('NO', style: smallBold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53E3E),
                    ),
                    child: const Text('YES', style: smallBold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
