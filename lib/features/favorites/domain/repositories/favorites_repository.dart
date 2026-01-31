import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Product>>> getFavorites();
  Future<Either<Failure, bool>> isFavorite(String productId);
  Future<Either<Failure, void>> toggleFavorite(Product product);
}
