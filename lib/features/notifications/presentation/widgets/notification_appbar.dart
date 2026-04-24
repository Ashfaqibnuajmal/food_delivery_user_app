import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/text_style.dart';

class NotificationAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showDivider;

  const NotificationAppbar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: appbarText),
      backgroundColor: Colors.white,
      centerTitle: centerTitle,
      elevation: 0,
      bottom: showDivider
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.black.withOpacity(0.1),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
