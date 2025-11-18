abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

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

class LocationError extends LocationState {
  final String message;

  LocationError({required this.message});
}
