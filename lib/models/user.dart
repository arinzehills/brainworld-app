class User {
  // final String role;

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profilePicture;
  final String? password;
  String? token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.profilePicture,
    this.password,
    this.token,
  });
  static User fromJson(Map<String, dynamic> json) => User(
        id: json['_id'],
        fullName: json['full_name'],
        profilePicture: json['profilePicture'],
        email: json['email'],
        phone: json['phone'],
        token: json['token'],
      );
  Map<String, Object?> toJson() => {
        // 'id': id,
        'full_name': fullName,
        'email': email,
        'profilePicture': profilePicture,
        'password': password,
        'token': token,
      };
}
