import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/features/address/cubit/add_address/add_address_cubit.dart';
import 'package:food_user_app/features/address/cubit/add_address/add_address_state.dart';
import 'package:food_user_app/features/address/cubit/address/address_cubit.dart';
import 'package:food_user_app/features/address/model/address_model.dart';
import 'package:food_user_app/features/address/presentation/add_address/widgets/add_address_button.dart';
import 'package:food_user_app/features/address/presentation/add_address/widgets/add_address_input_field.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nicknameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final address = AddressModel(
      id: "",
      label: _nicknameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      street: _addressCtrl.text.trim(),
    );
    await context.read<AddAddressCubit>().addAddress(address);
    // ignore: use_build_context_synchronously
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAddressCubit(context.read<AddressCubit>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "New Address"),
        body: BlocBuilder<AddAddressCubit, AddAddressState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddressInputField(
                      label: "Address Nickname",
                      hint: "Home, Office...",
                      controller: _nicknameCtrl,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nickname is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    AddressInputField(
                      label: "Full Address",
                      hint: "House no, Street, Area, City...",
                      controller: _addressCtrl,
                      maxLines: 3,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Address is required';
                        }
                        if (v.trim().length < 10) {
                          return 'Address too short';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    AddressInputField(
                      label: "Phone Number",
                      hint: "Enter phone number",
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(v.trim())) {
                          return 'Enter valid 10-digit number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    AddAddressButton(
                      isLoading: state.isLoading,
                      onPressed: () => _submit(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
