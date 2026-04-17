import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/theme/app_color.dart';
import 'package:food_user_app/core/widgets/appbar.dart';
import 'package:food_user_app/location/address_cubit.dart';
import 'package:food_user_app/location/address_model.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final address = AddressModel(
      id: '',
      label: _nicknameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      street: _addressCtrl.text.trim(),
    );

    await context.read<AddressCubit>().addAddress(address);

    if (mounted) Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "New Address"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Nickname
              const Text(
                "Address Nickname",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nicknameCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Home, Office..."),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nickname is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// 🔹 Address
              const Text(
                "Full Address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressCtrl,
                maxLines: 3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("House no, Street, Area, City..."),
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

              /// 🔹 Phone
              const Text(
                "Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Enter phone number"),
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

              /// 🔹 Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Add Address",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
