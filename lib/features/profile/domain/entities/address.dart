import 'package:equatable/equatable.dart';

/// Types d'adresse possibles.
enum AddressType { home, work, other }

/// Entité domaine représentant une adresse de livraison.
class Address extends Equatable {
  final String id;
  final String label;
  final String fullAddress;
  final bool isDefault;
  final AddressType type;
  final double? latitude;
  final double? longitude;

  const Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.isDefault = false,
    this.type = AddressType.other,
    this.latitude,
    this.longitude,
  });

  Address copyWith({
    String? id,
    String? label,
    String? fullAddress,
    bool? isDefault,
    AddressType? type,
    double? latitude,
    double? longitude,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      isDefault: isDefault ?? this.isDefault,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
    id,
    label,
    fullAddress,
    isDefault,
    type,
    latitude,
    longitude,
  ];
}
