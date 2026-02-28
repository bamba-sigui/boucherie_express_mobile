import 'package:equatable/equatable.dart';

/// Adresse de livraison.
class DeliveryAddress extends Equatable {
  final String id;
  final String title;
  final String detail;
  final String city;

  const DeliveryAddress({
    required this.id,
    required this.title,
    required this.detail,
    required this.city,
  });

  /// Adresse formatée sur une ligne.
  String get fullAddress => '$title • $city';

  bool get isValid => title.isNotEmpty && city.isNotEmpty;

  @override
  List<Object?> get props => [id, title, detail, city];
}
