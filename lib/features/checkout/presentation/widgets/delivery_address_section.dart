import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/features/checkout/presentation/widgets/show_address.dart';
import 'package:food_user_app/features/address/cubit/address/address_cubit.dart';
import 'package:food_user_app/features/address/model/address_model.dart';
import 'package:food_user_app/features/address/presentation/address/screen/address_screen.dart';
import 'package:food_user_app/features/address/cubit/location/location_cubit.dart';
import 'package:food_user_app/features/address/cubit/location/location_state.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryAddressSection extends StatefulWidget {
  const DeliveryAddressSection({super.key});

  @override
  State<DeliveryAddressSection> createState() => _DeliveryAddressSectionState();
}

class _DeliveryAddressSectionState extends State<DeliveryAddressSection> {
  // ✅ GPS off alert — Cancel button or Open Settings button
  void _showGPSAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.location_off, color: AppColors.primaryOrange),
            SizedBox(width: 8),
            Text("Device location", style: bigBold),
          ],
        ),
        content: const Text(
          "Your device's location (GPS) is turned off.\nPlease enable it from your device settings to use current location.",
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.primaryOrange),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await Geolocator.openLocationSettings(); // opens device GPS settings
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Open Settings"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _goToSavedAddresses(BuildContext context) async {
    final selected = await Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AddressCubit>(),
          child: const AddressScreen(),
        ),
      ),
    );

    if (selected != null && context.mounted) {
      context.read<LocationCubit>().selectManualAddress(
        label: selected.label,
        address: selected.street,
        phone: selected.phone,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state is LocationServiceDisabled) {
            _showGPSAlert(context);
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            final showManual = state is ManualAddressSelected;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Delivery Address", style: bigBold),
                    GestureDetector(
                      onTap: () => _goToSavedAddresses(context),
                      child: const Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// ✅ Manual Address
                if (showManual)
                  ShowAddress(
                    icon: Icons.home_outlined,
                    title: (state).label,
                    subtitle: state.address,
                    phone: state.phone,
                    onChangeTap: () => _goToSavedAddresses(context),
                  )
                /// Loading
                else if (state is LocationLoading)
                  const Center(child: LoadingIndicator())
                /// GPS Location
                else if (state is LocationLoaded)
                  ShowAddress(
                    icon: Icons.my_location,
                    title: "Current Location",
                    subtitle: state.address,
                    phone: "", // no phone for GPS
                    onChangeTap: () => _goToSavedAddresses(context),
                  )
                /// Error
                else if (state is LocationError)
                  Center(
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                // ── GPS Off — show image + hint + retry ──
                else if (state is LocationServiceDisabled)
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/location.jpeg',
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "GPS is off. Enable location and try again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<LocationCubit>()
                              .getCurrentLocation(),
                          icon: const Icon(Icons.my_location, size: 20),
                          label: const Text(
                            "Add Current Location",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(250, 50),
                          ),
                        ),
                      ],
                    ),
                  )
                // ── Initial state — no location yet ──
                else
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/location.jpeg',
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<LocationCubit>()
                              .getCurrentLocation(),
                          icon: const Icon(Icons.my_location, size: 20),
                          label: const Text(
                            "Add Current Location",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(250, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
