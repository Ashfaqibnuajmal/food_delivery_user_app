abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationServiceDisabled extends LocationState {}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;
  final String address;

  LocationLoaded({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class ManualAddressSelected extends LocationState {
  final String label;
  final String address;
  final String phone;
  ManualAddressSelected({
    required this.label,
    required this.address,
    required this.phone,
  });
}

class LocationError extends LocationState {
  final String message;
  LocationError({required this.message});
}
