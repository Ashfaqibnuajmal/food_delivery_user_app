import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/location/address_model.dart';

class AddressCubit extends Cubit<List<AddressModel>> {
  AddressCubit() : super([]) {
    loadAddresses();
  }

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _col => FirebaseFirestore.instance
      .collection('Users')
      .doc(_uid)
      .collection('Addresses');

  AddressModel? selectedAddress;

  void selectAddress(AddressModel? address) {
    selectedAddress = address;
    emit([...state]); // 🔥 force UI rebuild
  }

  Future<void> loadAddresses() async {
    try {
      final snapshot = await _col.get();

      final addresses = snapshot.docs
          .map(
            (doc) => AddressModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

      emit(addresses);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> addAddress(AddressModel address) async {
    final docRef = _col.doc();

    final newAddress = address.copyWith(id: docRef.id);

    await docRef.set(newAddress.toMap());

    emit([...state, newAddress]);
  }

  Future<void> removeAddress(String id) async {
    await _col.doc(id).delete();

    if (selectedAddress?.id == id) {
      selectedAddress = null;
    }

    emit(state.where((a) => a.id != id).toList());
  }
}
