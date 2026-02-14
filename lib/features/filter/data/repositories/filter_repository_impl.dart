import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../home/data/datasources/home_local_datasource.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/product_filter.dart';
import '../../domain/repositories/filter_repository.dart';

/// Implémentation concrète du [FilterRepository].
///
/// Utilise le [HomeLocalDataSource] partagé (source unique de vérité)
/// pour filtrer les produits en mémoire.
/// Prêt à être étendu avec une source remote (API).
@LazySingleton(as: FilterRepository)
class FilterRepositoryImpl implements FilterRepository {
  final HomeLocalDataSource _dataSource;

  const FilterRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Product>>> applyFilter(
    ProductFilter filter,
  ) async {
    try {
      // Récupérer tous les produits depuis la source partagée.
      final allProducts = await _dataSource.getProducts();

      // Appliquer les filtres en cascade.
      final filtered = allProducts.where((product) {
        // Filtre par catégorie
        if (filter.category != null &&
            filter.category!.isNotEmpty &&
            product.category != filter.category) {
          return false;
        }

        // Filtre par prix (range)
        if (product.price < filter.minPrice ||
            product.price > filter.maxPrice) {
          return false;
        }

        // Filtre par disponibilité (en stock)
        if (filter.inStock && product.stock <= 0) {
          return false;
        }

        return true;
      }).toList();

      return Right(filtered);
    } catch (e) {
      return const Left(
        ServerFailure('Erreur lors de l\'application des filtres'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final products = await _dataSource.getProducts();
      return Right(products);
    } catch (e) {
      return const Left(
        ServerFailure('Erreur lors de la récupération des produits'),
      );
    }
  }
}
