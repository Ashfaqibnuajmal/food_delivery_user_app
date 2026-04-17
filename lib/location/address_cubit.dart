import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'address_model.dart';

class AddressCubit extends Cubit<List<AddressModel>> {
  AddressCubit() : super([]) {
    loadAddresses(); // ✅ Auto-load from Firestore on app start
  }

  // ✅ Get current user's UID
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // ✅ Firestore collection: Users/{uid}/Addresses
  CollectionReference get _col => FirebaseFirestore.instance
      .collection('Users')
      .doc(_uid)
      .collection('Addresses');

  // ✅ Load all addresses from Firestore
  Future<void> loadAddresses() async {
    try {
      final snapshot = await _col.orderBy('createdAt', descending: false).get();
      final addresses = snapshot.docs
          .map((doc) =>
              AddressModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      emit(addresses);
    } catch (e) {
      emit([]); // If error, show empty list
    }
  }

  // ✅ Add new address to Firestore
  Future<void> addAddress(AddressModel address, {bool isDefault = false}) async {
    // If this is default, unset all other defaults in Firestore
    if (isDefault && state.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      for (final a in state.where((a) => a.isDefault)) {
        batch.update(_col.doc(a.id), {'isDefault': false});
      }
      await batch.commit();
    }

    // Create new Firestore doc reference (auto ID)
    final docRef = _col.doc();
    final newAddress = address.copyWith(id: docRef.id, isDefault: isDefault);

    // Save to Firestore with timestamp for ordering
    await docRef.set({
      ...newAddress.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update local state
    List<AddressModel> updated = [...state];
    if (isDefault) {
      updated = updated.map((a) => a.copyWith(isDefault: false)).toList();
    }
    updated.add(newAddress);
    emit(updated);
  }

  // ✅ Delete address from Firestore
  Future<void> removeAddress(String id) async {
    await _col.doc(id).delete();
    emit(state.where((a) => a.id != id).toList());
  }

  // ✅ Set a specific address as default
  Future<void> setDefault(String id) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final a in state) {
      batch.update(_col.doc(a.id), {'isDefault': a.id == id});
    }
    await batch.commit();
    emit(state.map((a) => a.copyWith(isDefault: a.id == id)).toList());
  }
}
