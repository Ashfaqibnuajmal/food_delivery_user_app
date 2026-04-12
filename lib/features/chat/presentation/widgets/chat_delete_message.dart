import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class DeleteMessageDialog extends StatelessWidget {
  final Future<void> Function() onDelete;

  const DeleteMessageDialog({super.key, required this.onDelete});

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
            // 🔴 Icon
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

            // 📝 Title
            const Text('Delete message?', style: bigBold),

            const SizedBox(height: 12),

            // 📄 Subtitle
            const Text(
              'Are you sure you want to delete\nthis message?',
              textAlign: TextAlign.center,
              style: greySmallTextStyle,
            ),

            const SizedBox(height: 24),

            // 🔘 Buttons
            Row(
              children: [
                // NO
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E5E5),
                      foregroundColor: Colors.black87,
                    ),
                    child: const Text('NO', style: smallBold),
                  ),
                ),

                const SizedBox(width: 12),

                // YES
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await onDelete();

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Message deleted!', style: redBold),
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          backgroundColor: Colors.white,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53E3E),
                      foregroundColor: Colors.white,
                      elevation: 0,
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
