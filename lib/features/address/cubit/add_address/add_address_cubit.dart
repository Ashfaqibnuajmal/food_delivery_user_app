import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/address/cubit/add_address/add_address_state.dart'
    show AddAddressState;
import 'package:food_user_app/features/address/cubit/address/address_cubit.dart';
import 'package:food_user_app/features/address/model/address_model.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  final AddressCubit addressCubit;

  AddAddressCubit(this.addressCubit) : super(AddAddressState());

  Future<void> addAddress(AddressModel address) async {
    emit(state.copyWith(isLoading: true));

    await addressCubit.addAddress(address);

    emit(state.copyWith(isLoading: false));
  }
}
