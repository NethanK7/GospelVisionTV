import 'package:cloud_firestore/cloud_firestore.dart';

class UserRole {
  final String uid;
  final String email;
  final String role; // 'user' or 'admin'
  final DateTime createdAt;

  UserRole({
    required this.uid,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'role': role, 'createdAt': createdAt};
  }

  factory UserRole.fromMap(Map<String, dynamic> map, String id) {
    return UserRole(
      uid: id,
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
