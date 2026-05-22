import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_state.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/core/widgets/shimmer_food_grid.dart';
import 'package:food_user_app/core/widgets/snack_bar.dart';
import 'package:food_user_app/features/profile/controller/profile_controller.dart';
import 'package:food_user_app/features/profile/presentation/widgets/chat_support_card.dart';
import 'package:food_user_app/features/profile/presentation/widgets/logout_card.dart';
import 'package:food_user_app/features/profile/presentation/widgets/order_history_card.dart';
import 'package:food_user_app/features/profile/presentation/widgets/profile_image_widget.dart';
import 'package:food_user_app/features/profile/presentation/widgets/profile_info_section.dart';
import 'package:food_user_app/features/profile/presentation/widgets/settings_card.dart';
import 'package:food_user_app/features/profile/presentation/widgets/theme_card.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  final ProfileController _controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Profile", showBack: false),
      body: StreamBuilder(
        stream: _controller.userProfileStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoader(type: ShimmerLayoutType.card);
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text("No user data found"));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: BlocConsumer<ImageBloc, ImageState>(
                listener: (context, state) {
                  if (state is ImageError) {
                    CustomSnackBar.redCustomSnackBar(context, state.message);
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: Column(
                      children: [
                        ProfileImageWidget(imageUrl: user.imageUrl),
                        const SizedBox(height: 10),
                        ProfileInfoSection(
                          name: user.name,
                          email: user.email,
                          phone: user.phone,
                          uid: user.uid,
                        ),
                        const SizedBox(height: 30),
                        const ChatSupportCard(),
                        OrderHistoryCard(),
                        SettingsCard(),
                        ThemeCard(),
                        LogoutCard(
                          showSnack: () {
                            _controller.showSnack(
                              context,
                              "You have been logged out successfully",
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
