class ProfileUserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String imageUrl;

  ProfileUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
  });

  factory ProfileUserModel.fromMap({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return ProfileUserModel(
      uid: uid,
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      phone: data['phone'] ?? "",
      imageUrl: data['imageUrl'] ?? "",
    );
  }
}
