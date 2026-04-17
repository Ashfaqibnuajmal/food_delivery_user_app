import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/core/widgets/loading.dart';
import 'package:food_user_app/location/address_card.dart';
import 'package:food_user_app/location/address_cubit.dart';
import 'package:food_user_app/location/address_model.dart';
import 'package:food_user_app/location/address_screen.dart';
import 'package:food_user_app/location/location_cubit.dart';
import 'package:food_user_app/location/location_state.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryAddressSection extends StatefulWidget {
  const DeliveryAddressSection({super.key});

  @override
  State<DeliveryAddressSection> createState() => _DeliveryAddressSectionState();
}

class _DeliveryAddressSectionState extends State<DeliveryAddressSection> {
  AddressModel? _manualAddress;

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

  // ✅ Open Address Screen — returns the selected AddressModel
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
    if (selected != null && mounted) {
      setState(() => _manualAddress = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) {
          // ✅ Show GPS alert dialog when GPS is off
          if (state is LocationServiceDisabled) {
            _showGPSAlert(context);
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            final showManual = _manualAddress != null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Delivery Address", style: bigBold),
                    // ✅ "Change" button always visible
                    GestureDetector(
                      onTap: () => _goToSavedAddresses(context),
                      child: const Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ── Manual address selected from Address Screen ──
                if (showManual)
                  AddressCard(
                    icon: Icons.home_outlined,
                    title: _manualAddress!.label,
                    subtitle: _manualAddress!.displayAddress,
                    name: _manualAddress!.fullName,
                    onChangeTap: () => _goToSavedAddresses(context),
                  )

                // ── GPS Loading ──
                else if (state is LocationLoading)
                  const Center(child: LoadingIndicator())

                // ── GPS Loaded (current location) ──
                else if (state is LocationLoaded)
                  AddressCard(
                    icon: Icons.my_location,
                    title: "Current Location",
                    subtitle: state.address,
                    onChangeTap: () => _goToSavedAddresses(context),
                  )

                // ── GPS Error ──
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
