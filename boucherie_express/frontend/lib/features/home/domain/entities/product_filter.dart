import 'package:equatable/equatable.dart';

/// Entité représentant les critères de filtrage des produits.
///
/// Immuable et sans dépendance externe (pure domain).
/// Prête pour une extension future (tri, popularité, etc.).
class ProductFilter extends Equatable {
  /// Catégorie sélectionnée (null = toutes les catégories).
  final String? category;

  /// Prix minimum du range slider.
  final double minPrice;

  /// Prix maximum du range slider.
  final double maxPrice;

  /// Filtrer uniquement les produits en stock.
  final bool inStock;

  const ProductFilter({
    this.category,
    this.minPrice = 0,
    this.maxPrice = 15000,
    this.inStock = false,
  });

  /// Filtre par défaut (aucun critère actif).
  static const ProductFilter defaultFilter = ProductFilter();

  /// Vérifie si le filtre a été modifié par rapport aux valeurs par défaut.
  bool get isActive =>
      category != null || minPrice > 0 || maxPrice < 15000 || inStock;

  /// Crée une copie avec les champs modifiés.
  ProductFilter copyWith({
    String? Function()? category,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  }) {
    return ProductFilter(
      category: category != null ? category() : this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      inStock: inStock ?? this.inStock,
    );
  }

  @override
  List<Object?> get props => [category, minPrice, maxPrice, inStock];
}
