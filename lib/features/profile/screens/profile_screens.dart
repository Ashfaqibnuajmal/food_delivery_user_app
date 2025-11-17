import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_event.dart';
import 'package:food_user_app/core/blocs/image/image_state.dart';
import 'package:food_user_app/core/routes/app_routes.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar_action.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:food_user_app/features/profile/screens/chat/chat_and_support.dart';
import 'package:food_user_app/features/profile/screens/order/order_history.dart';
import 'package:food_user_app/features/profile/screens/settings/settings.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  void _showSnack(String msg) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [CustomAppBarActions(showChatBot: false)],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(child: LoadingIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No user data found"));
              }

              final userData =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;
              final uid = snapshot.data!.docs.first.id;

              final name = userData['name'] ?? "";
              final email = userData['email'] ?? "";
              final phone = userData['phone'] ?? '';
              final imageUrl = userData['imageUrl'];

              return BlocConsumer<ImageBloc, ImageState>(
                listener: (context, state) {
                  if (state is ImageError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  final bloc = context.read<ImageBloc>();
                  return Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            bloc.add(PickImageEvent());
                          },
                          child: (imageUrl == null && state is! ImagePicked)
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: (state is ImagePicked)
                                      ? MemoryImage(state.imageBytes)
                                      : (imageUrl != null
                                                ? NetworkImage(imageUrl)
                                                : null)
                                            as ImageProvider?,
                                  onBackgroundImageError: (_, __) {},
                                  child:
                                      (state is! ImagePicked &&
                                          imageUrl == null)
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: const Icon(
                                            Icons.person,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : null,
                                ),
                        ),

                        // Name
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(email, style: const TextStyle(color: Colors.grey)),
                        Text(phone, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 10),

                        if (state is ImagePicked)
                          ElevatedButton(
                            onPressed: () {
                              bloc.add(UploadImageEvent(state.imageBytes, uid));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "Upload Image",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        if (state is ImageLoading) const LoadingIndicator(),
                        const SizedBox(height: 15),

                        // Divider with shadow
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Options directly as Cards
                        Card(
                          color: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrderHistory(),
                                ),
                              );
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.receipt_long,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Order history",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatAndSupport(),
                                ),
                              );
                            },
                            child: const ListTile(
                              leading: Icon(Icons.call, color: Colors.black),
                              title: Text(
                                "Chat with us",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Settings",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              showThemeBottomSheet(context);
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.brightness_6,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Theme",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Question mark icon in red circle
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

                                          // Title
                                          const Text(
                                            'Logout',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          // Message
                                          const Text(
                                            'Are you sure you want to Logout?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 24),

                                          // Buttons
                                          Row(
                                            children: [
                                              // NO button
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFE5E5E5),
                                                    foregroundColor:
                                                        Colors.black87,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'NO',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),

                                              // YES button
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    context
                                                        .read<AuthBlocBloc>()
                                                        .add(LogoutEvent());
                                                    _showSnack(
                                                      "You have been logged out seccessfully",
                                                    );
                                                    Navigator.pushNamedAndRemoveUntil(
                                                      context,
                                                      AppRoutes.login,
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFE53E3E),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  child: const Text(
                                                    'YES',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const ListTile(
                              leading: Icon(Icons.logout, color: Colors.black),
                              title: Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

void showThemeBottomSheet(BuildContext context) {
  String selectedTheme = "dark";

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Appearance",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Dark Mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Dark Mode",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Radio<String>(
                      value: "dark",
                      groupValue: selectedTheme,
                      activeColor: AppColors.primaryOrange,
                      onChanged: (value) {
                        setState(() => selectedTheme = value!);
                      },
                    ),
                  ],
                ),

                // Light Mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Light Mode",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Radio<String>(
                      value: "light",
                      groupValue: selectedTheme,
                      activeColor: AppColors.primaryOrange,
                      onChanged: (value) {
                        setState(() => selectedTheme = value!);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
