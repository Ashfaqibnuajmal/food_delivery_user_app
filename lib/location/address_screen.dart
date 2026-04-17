import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/location/add_address_screen.dart';
import 'package:food_user_app/location/address_cubit.dart';
import 'package:food_user_app/location/address_model.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  AddressModel? _selectedAddress;

  // ── Delete confirmation dialog ──
  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53E3E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Delete address?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              const Text(
                'Are you sure you want to delete\nthis address?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E5E5),
                      ),
                      child: const Text('NO'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedAddress?.id == id) {
                          setState(() => _selectedAddress = null);
                        }

                        context.read<AddressCubit>().removeAddress(id);
                        Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Address deleted!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53E3E),
                      ),
                      child: const Text('YES'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          final isSelected = _selectedAddress?.id == addr.id;

                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedAddress = isSelected ? null : addr;
                            }),
                            onLongPress: () =>
                                _showDeleteDialog(context, addr.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryOrange
                                      : Colors.grey.shade200,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: isSelected
                                        ? AppColors.primaryOrange
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 12),

                                  /// ✅ Clean Data UI
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addr.label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          addr.street,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          addr.phone,
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryOrange,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // ── Bottom section ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                      onPressed: _selectedAddress == null
                          ? null
                          : () => Navigator.pop(context, _selectedAddress),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
