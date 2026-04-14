import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'address_model.dart';

class AddressCubit extends Cubit<List<AddressModel>> {
  AddressCubit() : super([]);

  final _uuid = const Uuid();

  void addAddress(AddressModel address, {bool isDefault = false}) {
    List<AddressModel> updated = [...state];

    // If this is default, unset all others
    if (isDefault) {
      updated = updated.map((a) => a.copyWith(isDefault: false)).toList();
    }

    updated.add(address.copyWith(id: _uuid.v4(), isDefault: isDefault));
    emit(updated);
  }

  void removeAddress(String id) {
    emit(state.where((a) => a.id != id).toList());
  }

  void setDefault(String id) {
    emit(state.map((a) => a.copyWith(isDefault: a.id == id)).toList());
  }
}
