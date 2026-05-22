import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_user_app/features/profile/data/model/profile_user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<ProfileUserModel?> getUserProfile() {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Stream.value(null);
    }

    final uid = currentUser.uid;

    return _firestore
        .collection("Users")
        .where("id", isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;

          final doc = snapshot.docs.first;
          final data = doc.data();

          return ProfileUserModel.fromMap(
            uid: data["id"] ?? doc.id,
            data: data,
          );
        });
  }
}
