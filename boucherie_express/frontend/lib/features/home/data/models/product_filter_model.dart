import '../../domain/entities/product_filter.dart';

/// Modèle de données pour [ProductFilter].
///
/// Gère la sérialisation/désérialisation JSON pour les appels API futurs.
/// Actuellement utilisé pour transformer le filtre domain en requête data.
class ProductFilterModel extends ProductFilter {
  const ProductFilterModel({
    super.category,
    super.minPrice,
    super.maxPrice,
    super.inStock,
  });

  /// Crée un modèle depuis l'entité domain.
  factory ProductFilterModel.fromEntity(ProductFilter filter) {
    return ProductFilterModel(
      category: filter.category,
      minPrice: filter.minPrice,
      maxPrice: filter.maxPrice,
      inStock: filter.inStock,
    );
  }

  /// Sérialisation vers JSON (prêt pour API).
  Map<String, dynamic> toJson() {
    return {
      if (category != null) 'category': category,
      'min_price': minPrice,
      'max_price': maxPrice,
      'in_stock': inStock,
    };
  }

  /// Désérialisation depuis JSON (prêt pour API).
  factory ProductFilterModel.fromJson(Map<String, dynamic> json) {
    return ProductFilterModel(
      category: json['category'] as String?,
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 0,
      maxPrice: (json['max_price'] as num?)?.toDouble() ?? 15000,
      inStock: json['in_stock'] as bool? ?? false,
    );
  }
}
