import 'package:equatable/equatable.dart';

/// Product entity
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final List<String> images;
  final String? videoUrl;
  final String category;
  final List<String> preparationOptions; // Entier, Découpé, Nettoyé
  final bool isBio;
  final bool isFresh;
  final String farmName;
  final int stock;
  final String unit; // kg, unité, etc.

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.images,
    this.videoUrl,
    required this.category,
    this.preparationOptions = const ['Entier'],
    this.isBio = false,
    this.isFresh = true,
    this.farmName = 'Ferme Locale',
    this.stock = 0,
    this.unit = 'unité',
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((oldPrice! - price) / oldPrice!) * 100;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    oldPrice,
    images,
    videoUrl,
    category,
    preparationOptions,
    isBio,
    isFresh,
    farmName,
    stock,
    unit,
  ];
}
