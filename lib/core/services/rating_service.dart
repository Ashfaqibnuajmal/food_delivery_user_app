import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingServices {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> saveUserRating(String foodId, double rating) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User Not Logged In!");
    }

    final foodRef = _firestore.collection('FoodItems').doc(foodId);

    // Step 1: Save or update user's rating
    await foodRef.collection('ratings').doc(user.uid).set({
      'rating': rating,
      'userName': user.displayName ?? 'Anonymous',
      'userId': user.uid,
    });

    // Step 2: Get all ratings
    final ratingsSnapshot = await foodRef.collection('ratings').get();

    double total = 0;
    for (var doc in ratingsSnapshot.docs) {
      total += (doc['rating'] ?? 0).toDouble();
    }

    double avg = total / ratingsSnapshot.docs.length;
    int count = ratingsSnapshot.docs.length;

    // Step 3: Update both averageRating and totalRatings
    await foodRef.update({
      'averageRating': avg,
      'totalRatings': count,
    });
  }

  /// Stream to get both average and total ratings live
  static Stream<Map<String, dynamic>> getRatingData(String foodId) {
    return _firestore
        .collection('FoodItems')
        .doc(foodId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {'averageRating': 0.0, 'totalRatings': 0};
      }

      final data = snapshot.data() ?? {};
      return {
        'averageRating': (data['averageRating'] ?? 0.0).toDouble(),
        'totalRatings': (data['totalRatings'] ?? 0),
      };
    });
  }

  static Stream<double> getAverageRating(String foodId) {
    return FirebaseFirestore.instance
        .collection('FoodItems')
        .doc(foodId)
        .collection('Ratings')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return 0.0;
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['rating'] ?? 0).toDouble();
      }
      return total / snapshot.docs.length;
    });
  }
}
