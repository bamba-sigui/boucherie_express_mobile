import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final List<String> addresses;
  final String? photoUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.addresses = const [],
    this.photoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    addresses,
    photoUrl,
    createdAt,
  ];
}
