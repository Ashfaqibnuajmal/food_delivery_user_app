// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// import 'location_state.dart';

// class LocationCubit extends Cubit<LocationState> {
//   LocationCubit() : super(LocationInitial());

//   Future<void> getCurrentLocation() async {
//     emit(LocationLoading());

//     try {
//       // Check if GPS is ON
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         emit(LocationError(message: "Please enable location services (GPS)."));
//         return;
//       }

//       // Check permissions
//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();

//         if (permission == LocationPermission.denied) {
//           emit(LocationError(message: "Location permission denied."));
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         emit(
//           LocationError(
//             message:
//                 "Location permission permanently denied. Enable it from app settings.",
//           ),
//         );
//         return;
//       }

//       // Get location using NEW method (NO deprecated error)
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.best, // Best accuracy
//           timeLimit: Duration(seconds: 10),
//         ),
//       );

//       // Convert lat/lng to address
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       String address = "Unknown location";

//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         address =
//             "${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
//       }

//       emit(
//         LocationLoaded(
//           latitude: position.latitude,
//           longitude: position.longitude,
//           address: address,
//         ),
//       );
//     } catch (e) {
//       emit(LocationError(message: "Error getting location: $e"));
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    emit(LocationLoading());

    try {
      // Check if GPS is ON
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationError(message: "Please enable location services (GPS)."));
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          emit(LocationError(message: "Location permission denied."));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          LocationError(
            message:
                "Location permission permanently denied. Enable it from app settings.",
          ),
        );
        return;
      }

      // Get location using NEW method (NO deprecated error)
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best, // Best accuracy
        ),
      );

      // Convert lat/lng to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Unknown location";

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        address =
            "${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
      }

      emit(
        LocationLoaded(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ),
      );
    } catch (e) {
      emit(LocationError(message: "Error getting location: $e"));
    }
  }
}
