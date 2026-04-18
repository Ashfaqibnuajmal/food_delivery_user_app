import 'package:flutter/material.dart';
import 'package:food_user_app/core/widgets/appbar_action.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,

      // Left logo
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset(
          "assets/Logo.jpeg", // replace with your logo
          height: 50,
          width: 50,
        ),
      ),
      actions: const [CustomAppBarActions(showChatBot: true)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
