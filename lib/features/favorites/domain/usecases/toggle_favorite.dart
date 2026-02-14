import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/favorites_repository.dart';

/// Use case : retirer un produit des favoris.
@injectable
class RemoveFavorite {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  Future<Either<Failure, void>> call(String productId) async {
    return await repository.removeFavorite(productId);
  }
}
