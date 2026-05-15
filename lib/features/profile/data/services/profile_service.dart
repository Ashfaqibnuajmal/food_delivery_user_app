import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_user_app/features/profile/data/model/profile_user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<ProfileUserModel?> getUserProfile() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();

      return ProfileUserModel.fromMap(uid: doc.id, data: data);
    });
  }
}
