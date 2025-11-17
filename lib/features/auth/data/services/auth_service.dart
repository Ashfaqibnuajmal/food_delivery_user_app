import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_user_app/features/auth/data/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<bool> checkUserLoggedIn() async {
    try {
      final sharedpref = await SharedPreferences.getInstance();
      if (sharedpref.getBool("_isfirstTime") != true ||
          sharedpref.getBool("_isfirstTime") == null) {
        sharedpref.setBool("_isfirstTime", true);
      }
      return false;
    } catch (e) {
      log(e.toString());
    }
    return true;
  }

  Future<bool> checkUser() async {
    await Future.delayed(const Duration(seconds: 2));
    User? logincheck = auth.currentUser;
    log("$logincheck");
    if (logincheck != null) {
      return true;
    }
    return false;
  }

  String? getUserId() {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        return user.uid;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  void signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }

  void passWordReset(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> googleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw "Google sign in aborted by the user";
      }
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final gcred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await auth.signInWithCredential(gcred);
      return auth.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      log("google sign in error${e.toString()}");
      rethrow;
    }
  }

  Future<String?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential currentUser = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return currentUser.user!.uid;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String?> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final UserCredential currentUser = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel newUser = UserModel(
        name: name,
        email: email,
        password: password,
        uid: currentUser.user!.uid,
        phone: phone,
      );
      await db.collection("Users").doc(newUser.uid).set(newUser.toMap());
      return currentUser.user!.uid;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
