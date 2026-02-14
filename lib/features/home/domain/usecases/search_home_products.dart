import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/home_repository.dart';

/// Cas d'utilisation : rechercher des produits par mot-clé.
@lazySingleton
class SearchHomeProducts {
  final HomeRepository repository;

  const SearchHomeProducts(this.repository);

  Future<Either<Failure, List<Product>>> call(String query) {
    return repository.searchProducts(query);
  }
}
