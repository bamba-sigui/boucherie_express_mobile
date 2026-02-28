import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/domain/entities/product.dart';
import '../entities/product_filter.dart';
import '../repositories/filter_repository.dart';

/// Cas d'utilisation : appliquer un filtre sur les produits.
///
/// Délègue au repository et retourne les produits filtrés.
@lazySingleton
class ApplyFilter {
  final FilterRepository repository;

  const ApplyFilter(this.repository);

  Future<Either<Failure, List<Product>>> call(ProductFilter filter) {
    return repository.applyFilter(filter);
  }
}
