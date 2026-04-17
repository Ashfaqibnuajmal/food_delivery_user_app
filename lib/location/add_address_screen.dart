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
  bool _isDefault = false;
  bool _isSaving = false;

  final _nicknameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _fullAddressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _fullNameCtrl.dispose();
    _fullAddressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final address = AddressModel(
      id: '',
      label: _nicknameCtrl.text.trim(),
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      street: _fullAddressCtrl.text.trim(),
      city: '',
      state: '',
      pincode: '',
      isDefault: _isDefault,
    );

    // ✅ Awaits Firestore save before going back
    await context
        .read<AddressCubit>()
        .addAddress(address, isDefault: _isDefault);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.grey.shade400, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'This field is required' : null,
        ),
        const SizedBox(height: 20),
      ],
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
              // ── Address Nickname (e.g. Home, Office) ──
              _buildField(
                "Address Nickname",
                "e.g. Home, Office, Other...",
                _nicknameCtrl,
              ),

              // ── Full Name ──
              _buildField(
                "Full Name",
                "Enter your full name...",
                _fullNameCtrl,
              ),

              // ── Full Address ──
              _buildField(
                "Full Address",
                "House no, Street, Area, City...",
                _fullAddressCtrl,
                maxLines: 3,
              ),

              // ── Phone Number ──
              _buildField(
                "Phone Number",
                "Enter phone number...",
                _phoneCtrl,
                keyboardType: TextInputType.phone,
              ),

              // ── Make Default checkbox ──
              GestureDetector(
                onTap: () => setState(() => _isDefault = !_isDefault),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _isDefault
                            ? AppColors.primaryOrange
                            : Colors.white,
                        border: Border.all(
                          color: _isDefault
                              ? AppColors.primaryOrange
                              : Colors.grey.shade400,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _isDefault
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Make this as a default address",
                      style:
                          TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ── Add Button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primaryOrange.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Add Address",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
