import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/services/image_services.dart';
import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageServices imageServices;

  ImageBloc(this.imageServices) : super(ImageInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<UploadImageEvent>(_onUploadImage);
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      emit(ImageLoading());
      final image = await imageServices.pickImage();
      if (image != null) {
        emit(ImagePicked(image));
      } else {
        emit(ImageError("No image selected"));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      emit(ImageLoading());
      final imageUrl = await imageServices.uploadToCloudinary(event.imageBytes);
      if (imageUrl != null) {
        await imageServices.updateUserImage(event.uid, imageUrl);
        emit(ImageUploaded(imageUrl));
      } else {
        emit(ImageError("Upload failed"));
      }
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }
}
