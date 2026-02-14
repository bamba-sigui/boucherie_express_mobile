import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/product_filter.dart';

/// Contrat du repository pour la feature Filter.
///
/// Abstraction pure (domain layer) — aucune dépendance framework.
/// L'implémentation concrète est dans le data layer.
abstract class FilterRepository {
  /// Applique un filtre et retourne les produits correspondants.
  Future<Either<Failure, List<Product>>> applyFilter(ProductFilter filter);

  /// Récupère tous les produits sans filtre (pour le reset).
  Future<Either<Failure, List<Product>>> getAllProducts();
}
