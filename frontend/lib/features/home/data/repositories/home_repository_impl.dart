import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/domain/entities/product.dart';
import '../../domain/entities/home_category.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

/// Implémentation concrète du [HomeRepository].
///
/// Délègue les appels à la source de données locale (mock).
/// Prête à être étendue avec une source remote.
@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  const HomeRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? categoryId,
  }) async {
    try {
      final products = await localDataSource.getProducts(
        categoryId: categoryId,
      );
      return Right(products);
    } catch (e) {
      print('HomeRepo.getProducts error: $e');
      return Left(
        ServerFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<HomeCategory>>> getCategories() async {
    try {
      final categories = await localDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      print('HomeRepo.getCategories error: $e');
      return Left(
        ServerFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String productId) async {
    try {
      await localDataSource.toggleFavorite(productId);
      return const Right(null);
    } catch (e) {
      return const Left(
        ServerFailure('Erreur lors de la mise à jour du favori'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final products = await localDataSource.searchProducts(query);
      return Right(products);
    } catch (e) {
      return const Left(ServerFailure('Erreur lors de la recherche'));
    }
  }

  @override
  Future<Either<Failure, Set<String>>> getFavoriteIds() async {
    try {
      final ids = localDataSource.favoriteIds;
      return Right(Set<String>.from(ids));
    } catch (e) {
      return const Left(
        ServerFailure('Erreur lors de la récupération des favoris'),
      );
    }
  }
}
