import 'package:equatable/equatable.dart';

/// Informations sur le livreur.
class Courier extends Equatable {
  final String id;
  final String name;
  final double rating;
  final String vehicle;
  final String phone;
  final String photoUrl;

  const Courier({
    required this.id,
    required this.name,
    required this.rating,
    required this.vehicle,
    required this.phone,
    required this.photoUrl,
  });

  /// `true` si le livreur est joignable (numéro valide).
  bool get canCall => phone.isNotEmpty;

  @override
  List<Object?> get props => [id, name, rating, vehicle, phone];
}
