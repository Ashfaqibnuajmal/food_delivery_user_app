class UserModel {
  String name;
  String email;
  String phone;
  String uid;
  String password;
  String? imageUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.uid,
    required this.phone,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": uid,
      "name": name,
      "password": password,
      "email": email,
      "phone": phone,
      "imageUrl": imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map["name"] ?? "",
      password: map["password"] ?? "",
      uid: map["id"] ?? "",
      phone: map["phone"] ?? "",
      email: map['email'] ?? "",
      imageUrl: map["imageUrl"],
    );
  }
}
