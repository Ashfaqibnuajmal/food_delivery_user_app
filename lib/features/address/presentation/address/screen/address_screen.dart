import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/features/address/cubit/address/address_cubit.dart';
import 'package:food_user_app/features/address/model/address_model.dart';
import 'package:food_user_app/features/address/presentation/address/widgets/address_bottom_navigation.dart';
import 'package:food_user_app/features/address/presentation/address/widgets/address_card.dart';
import 'package:food_user_app/features/address/presentation/address/widgets/adress_delete_dilog.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => DeleteAddressDialog(
        onConfirm: () {
          context.read<AddressCubit>().removeAddress(id);
          Navigator.pop(context);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Address deleted')));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddressCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Address"),
      body: BlocBuilder<AddressCubit, List<AddressModel>>(
        builder: (context, addresses) {
          return Column(
            children: [
              Expanded(
                child: addresses.isEmpty
                    ? const Center(child: Text("No saved addresses"))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: addresses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final addr = addresses[index];
                          final isSelected =
                              cubit.selectedAddress?.id == addr.id;
                          return AddressCard(
                            address: addr,
                            isSelected: isSelected,
                            onTap: () =>
                                cubit.selectAddress(isSelected ? null : addr),
                            onLongPress: () =>
                                _showDeleteDialog(context, addr.id),
                          );
                        },
                      ),
              ),

              // ── Bottom section ──
              AddressBottomSection(
                isEnabled: cubit.selectedAddress != null,
                onApply: () {
                  Navigator.pop(context, cubit.selectedAddress);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
