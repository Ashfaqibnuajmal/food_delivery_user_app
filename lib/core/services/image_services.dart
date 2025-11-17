import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_user_app/core/services/cloudinary.dart';
import 'package:image_picker/image_picker.dart';

class ImageServices {
  final picker = ImagePicker();

  Future<Uint8List?> pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<String?> uploadToCloudinary(Uint8List image) async {
    return await CloudinaryService.uploadImage(image);
  }

  Future<void> updateUserImage(String uid, String imageUrl) async {
    await FirebaseFirestore.instance.collection("Users").doc(uid).update({
      "imageUrl": imageUrl,
    });
  }
}
