import 'package:flutter/material.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/features/profile/data/model/profile_user_model.dart';
import 'package:food_user_app/features/profile/data/services/profile_service.dart';

class ProfileController {
  final ProfileService _profileService = ProfileService();

  Stream<ProfileUserModel?> get userProfileStream {
    return _profileService.getUserProfile();
  }

  void showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            msg,
            style: const TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
