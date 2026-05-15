import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_bloc.dart';
import 'package:food_user_app/core/blocs/image/image_event.dart';
import 'package:food_user_app/core/blocs/image/image_state.dart';
import 'package:shimmer/shimmer.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;

  const ProfileImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ImageBloc>();

    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            bloc.add(PickImageEvent());
          },
          child: ClipOval(
            child: state is ImagePicked
                ? Image.memory(
                    state.imageBytes,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : imageUrl.toString().isNotEmpty
                ? Image.network(
                    imageUrl.toString(),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
