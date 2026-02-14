import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/filter_repository.dart';

/// Cas d'utilisation : réinitialiser les filtres.
///
/// Retourne tous les produits sans filtre appliqué.
@lazySingleton
class ResetFilter {
  final FilterRepository repository;

  const ResetFilter(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getAllProducts();
  }
}
