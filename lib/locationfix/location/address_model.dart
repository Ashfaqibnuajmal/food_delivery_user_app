class AddressModel {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.isDefault = false,
  });

  String get displayAddress => street;

  AddressModel copyWith({
    String? id,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
