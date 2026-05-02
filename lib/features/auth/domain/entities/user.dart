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

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    List<String>? addresses,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addresses: addresses ?? this.addresses,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
