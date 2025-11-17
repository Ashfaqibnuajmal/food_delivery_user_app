import 'dart:typed_data';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImagePicked extends ImageState {
  final Uint8List imageBytes;
  ImagePicked(this.imageBytes);
}

class ImageUploaded extends ImageState {
  final String imageUrl;
  ImageUploaded(this.imageUrl);
}

class ImageError extends ImageState {
  final String message;
  ImageError(this.message);
}
