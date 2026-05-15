import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_event.dart';
import 'package:food_user_app/core/blocs/image/image_state.dart';
import 'package:food_user_app/core/widgets/loading.dart';

class ProfileInfoSection extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String uid;

  const ProfileInfoSection({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ImageBloc>();

    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          ],
        );
      },
    );
  }
}
