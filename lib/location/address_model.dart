class AddressModel {
  final String id;
  final String label; // Home, Office, etc.
  final String phone;
  final String street; // Full address

  AddressModel({
    required this.id,
    required this.label,
    required this.phone,
    required this.street,
  });

  // ✅ For UI display
  String get displayAddress => street;

  // ✅ Convert to Firestore
  Map<String, dynamic> toMap() {
    return {'id': id, 'label': label, 'phone': phone, 'street': street};
  }

  // ✅ From Firestore
  factory AddressModel.fromMap(String docId, Map<String, dynamic> map) {
    return AddressModel(
      id: docId,
      label: map['label'] ?? '',
      phone: map['phone'] ?? '',
      street: map['street'] ?? '',
    );
  }

  // ✅ Copy
  AddressModel copyWith({
    String? id,
    String? label,
    String? phone,
    String? street,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      phone: phone ?? this.phone,
      street: street ?? this.street,
    );
  }
}
