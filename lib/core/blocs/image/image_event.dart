import 'dart:typed_data';

abstract class ImageEvent {}

class PickImageEvent extends ImageEvent {}

class UploadImageEvent extends ImageEvent {
  final Uint8List imageBytes;
  final String uid;
  UploadImageEvent(this.imageBytes, this.uid);
}
