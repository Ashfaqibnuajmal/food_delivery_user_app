import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/theme/text_style.dart';
import 'package:food_user_app/features/address/presentation/add_address/screen/add_address_screen.dart';
import 'package:food_user_app/features/address/cubit/address_cubit.dart';

class AddressBottomSection extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onApply;

  const AddressBottomSection({
    super.key,
    required this.isEnabled,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          OutlinedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AddressCubit>(),
                    child: const AddAddressScreen(),
                  ),
                ),
              );

              if (context.mounted) {
                context.read<AddressCubit>().loadAddresses();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Add New Address"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: isEnabled ? onApply : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Apply", style: whiteBoldSmallTextStyle),
          ),
        ],
      ),
    );
  }
}
