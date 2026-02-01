import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.role = 'user',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, phone, role, createdAt];
}
