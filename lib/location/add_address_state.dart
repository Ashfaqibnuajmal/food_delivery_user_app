class AddAddressState {
  final bool isLoading;

  AddAddressState({this.isLoading = false});

  AddAddressState copyWith({bool? isLoading}) {
    return AddAddressState(isLoading: isLoading ?? this.isLoading);
  }
}
