import 'package:equatable/equatable.dart';

/// Types de paiement disponibles.
enum PaymentMethodType { mobileMoney, cash }

/// Méthode de paiement sélectionnable par l'utilisateur.
class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String description;
  final PaymentMethodType type;

  /// URL du logo (ou `null` pour icône Material).
  final String? logoUrl;

  /// Couleur de fond du logo (hex string, ex: `#FFCC00`).
  final int? logoBgColor;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.logoUrl,
    this.logoBgColor,
  });

  @override
  List<Object?> get props => [id, name, type];
}
