import 'user_role.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final UserRole role;
  String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.role = UserRole.user,
    this.profileImage,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    UserRole? role,
    String? profileImage,
    List<String>? medicalHistory,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'role': role.toMap(),
      'profileImage': profileImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: DateTime.parse(map['createdAt']),
      role: map['role'] != null ? UserRole.fromMap(map['role']) : UserRole.user,
      profileImage: map['profileImage'],
    );
  }
}
